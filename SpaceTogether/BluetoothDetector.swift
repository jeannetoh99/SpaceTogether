//
//  BluetoothDetector.swift
//  SpaceTogether
//
//  Created by elsa on 8/1/21.
//

import Foundation
import CoreBluetooth
import Combine
import UIKit

public struct PeripheralCharacteristicsDataV2: Codable {
    var mp: String // phone model of peripheral
    var id: String // tempID
    var o: String // organisation
    var v: Int // protocol version
}

class BluetoothDetector: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate{
    
    
    let BluetoothServiceID = CBUUID(string: "\(getvalueFromInfoPlist(withKey: "TRACER_SVC_ID") ?? "B9B15DA3-7814-498E-AC05-3A483F60375A")")

    static let CharacteristicServiceIDv2 = CBUUID(string: "\(getvalueFromInfoPlist(withKey: "V2_CHARACTERISTIC_ID") ?? "D1034710-B11E-42F2-BCA3-F481177D5BB2")")

    var didChange = PassthroughSubject<Void, Never>()
    var centralDidUpdateStateCallback: ((CBManagerState) -> Void)?

    var centralManager : CBCentralManager!
    var peripheralManager : CBPeripheralManager!
    
    var peripheral: CBPeripheral?
    var queue: DispatchQueue!
    var timerForScanning: Timer?
 


    override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    static func getvalueFromInfoPlist(withKey key: String) -> String? {
            if  let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
                let keyValue = NSDictionary(contentsOfFile: path)?.value(forKey: key) as? String {
                return keyValue
            }
            return nil
        }
    
    func presentBluetoothAlert() {
               
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url as URL)
                }
            }
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let alert = UIAlertController(title: "SpaceTogether needs bluetooth to work", message: "Go to settings > bluetooth to turn on", preferredStyle: .alert)
        
        alert.addAction(settingsAction)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            while topController?.presentedViewController != nil {
                topController = topController?.presentedViewController
            }

            if topController!.isKind(of: UIAlertController.self) {
                print("Alert has already popped up!")
            } else {
                topController?.present(alert, animated: true)
            }

        }
    }
    
    func handlePeripheralOfUncertainStatus(_ peripheral: CBPeripheral) {
            // If not connected to Peripheral, attempt connection and exit
            if peripheral.state != .connected {
                print("CC handlePeripheralOfUncertainStatus not connected")
                centralManager?.connect(peripheral)
                return
            }
            // If don't know about Peripheral's services, discover services and exit
            if peripheral.services == nil {
                print("CC handlePeripheralOfUncertainStatus unknown services")
                peripheral.discoverServices([BluetoothServiceID])
                return
            }
            // If Peripheral's services don't contain targetID, disconnect and remove, then exit.
            // If it does contain targetID, discover characteristics for service
            guard let service = peripheral.services?.first(where: { $0.uuid == BluetoothServiceID }) else {
                print("CC handlePeripheralOfUncertainStatus no matching Services")
                centralManager?.cancelPeripheralConnection(peripheral)
                return
            }
            print("CC handlePeripheralOfUncertainStatus discoverCharacteristics")
            peripheral.discoverCharacteristics([BluetoothServiceID], for: service)
            // If Peripheral's service's characteristics don't contain targetID, disconnect and remove, then exit.
            // If it does contain targetID, read value for characteristic
            guard let characteristic = service.characteristics?.first(where: { $0.uuid == BluetoothServiceID}) else {
                print("CC handlePeripheralOfUncertainStatus no matching Characteristics")
                centralManager?.cancelPeripheralConnection(peripheral)
                return
            }
            print("CC handlePeripheralOfUncertainStatus readValue")
            peripheral.readValue(for: characteristic)
            return
        }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            centralDidUpdateStateCallback?(central.state)
            switch central.state {
            case .poweredOn:
                DispatchQueue.main.async {
                    self.timerForScanning = Timer.scheduledTimer(withTimeInterval: TimeInterval(60), repeats: true) { _ in
                        print("CC Starting a scan")
                        
                        central.scanForPeripherals(withServices: [self.BluetoothServiceID], options: nil)
                        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(60)) {
                            print("CC Stopping a scan")
                        }
                    }
                    
                    self.timerForScanning?.fire()
                }
            default:
                timerForScanning?.invalidate()
                presentBluetoothAlert()
            }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("discovered peripheral")
            let debugLogs = ["CentralState": managerStateToString(central.state),
                             "peripheral": peripheral,
                             "advertisments": advertisementData as AnyObject] as AnyObject

            print("\(debugLogs)")

            // iphones will "mask" the peripheral's identifier for android devices, resulting in the same android device being discovered multiple times with different peripheral identifier. Hence android is using CBAdvertisementDataServiceDataKey data for identifying an android pheripheral
            if let manuData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
                
                let androidIdentifierData = manuData.subdata(in: 2..<manuData.count)
               
                peripheral.delegate = self
               
                central.connect(peripheral)
                
            } else {
                // Means this is not an android device. We check if the peripheral.identifier exist in the scannedPeripherals
                print("Peripheral is likely not android")
                peripheral.delegate = self
                central.connect(peripheral)
               
            }

            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(60)) {
                print("terminating connection")
                self.centralManager.cancelPeripheralConnection(peripheral)
            }
            
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
        
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected!")
        self.peripheral = peripheral
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        let service = CBMutableService(type: BluetoothServiceID, primary: true)
        if(peripheral.state == .poweredOn){
            peripheral.add(service)
            peripheral.startAdvertising(["String" : "cereal"])
        }
    }
        
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
            print("\(["request": request] as AnyObject)")
        }
        
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests{
            print("\(["request": request] as AnyObject)")
        }
    }

    
        
    func managerStateToString(_ state: CBManagerState) -> String {
            switch state {
            case .poweredOff:
                return "poweredOff"
            case .poweredOn:
                return "poweredOn"
            case .resetting:
                return "resetting"
            case .unauthorized:
                return "unauthorized"
            case .unknown:
                return "unknown"
            case .unsupported:
                return "unsupported"
            default:
                return "unknown"
            }
        }

    
}


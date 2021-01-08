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

class BluetoothDetector: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var didChange = PassthroughSubject<Void, Never>()
    var centralManager : CBCentralManager!
    var peripheral: CBPeripheral?
    
    override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var consoleLog = ""
        
        switch central.state {
          case .poweredOff:
            consoleLog = "BLE is Off"
            presentBluetoothAlert()
            
          case .poweredOn:
            consoleLog = "BLE is On"
            self.centralManager?.scanForPeripherals(withServices: nil , options: nil)
            
          case .resetting:
              consoleLog = "BLE is resetting"
            
          case .unauthorized:
              consoleLog = "BLE is unauthorized"
              presentBluetoothAlert()
            
          case .unknown:
              consoleLog = "BLE is unknown"
          case .unsupported:
              consoleLog = "BLE is unsupported"
          default:
                  consoleLog = "default"
            }
       print(consoleLog)
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("found peripheral")
     }
        
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
           
        guard peripheral.state == .poweredOn else { return }
        let advertisementData: [String: Any] = [CBAdvertisementDataLocalNameKey: ""]

        peripheral.removeAllServices()

        peripheral.startAdvertising(advertisementData)
    }
    
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {}
        
            

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
            
            peripheral.respond(to: requests[0], withResult: .success)

        }
    
    

    

}

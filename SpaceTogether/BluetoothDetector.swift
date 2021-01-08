//
//  BluetoothDetector.swift
//  SpaceTogether
//
//  Created by elsa on 8/1/21.
//

import Foundation
import CoreBluetooth
import Combine

public struct PeripheralCharacteristicsDataV2: Codable {
    var mp: String // phone model of peripheral
    var id: String // tempID
    var o: String // organisation
    var v: Int // protocol version
}

class BluetoothDetector: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var didChange = PassthroughSubject<Void, Never>()
    var centralManager : CBCentralManager?
    var peripheral: CBPeripheral?
    
    override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        }else{
            self.centralManager? = CBCentralManager.init(delegate:self, queue: nil)

        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.peripheral?.delegate = self

        centralManager?.connect(peripheral, options: nil)
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


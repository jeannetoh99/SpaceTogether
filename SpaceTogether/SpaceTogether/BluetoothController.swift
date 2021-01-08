//
//  BluetoothController.swift
//  SpaceTogether
//
//  Created by elsa on 8/1/21.
//

import Foundation
import CoreBluetooth

class BluetoothController : NSObject {
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?


    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}


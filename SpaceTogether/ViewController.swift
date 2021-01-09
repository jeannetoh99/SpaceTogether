//
//  ViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import CoreData
import CoreBluetooth

class ViewController: UIViewController {
    //var bluetoothDetector : BluetoothDetector!
    
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

    override func viewDidLoad() {
        super.viewDidLoad()
        //bluetoothDetector = BluetoothDetector()

        // Do any additional setup after loading the view.
        print("View has loaded :)")
        BluetraceManager.shared.turnOn()
        registerForPushNotifications()
        let blePoweredOn = BluetraceManager.shared.isBluetoothOn()
        let bleAuthorized = BluetraceManager.shared.isBluetoothAuthorized()
        BlueTraceLocalNotifications.shared.checkAuthorization { (granted) in
            if granted && blePoweredOn && bleAuthorized {
                print("Bluetooth On!")
            }
        }
    }
    
    @IBAction func shieldMeNowButtonPressed(_ sender: UIButton) {
        print("shield me now!")
        self.performSegue(withIdentifier: "HomeToSafeSegue", sender: self)
    }
    
    @IBAction func setMyOwnAlarmButtonPressed(_ sender: UIButton) {
        print("set my own alarm!")
        self.performSegue(withIdentifier: "HomeToRecordSegue", sender: self)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        print("unwind to home page")
    }
    
    func registerForPushNotifications() {
        BlueTraceLocalNotifications.shared.checkAuthorization { (_) in
            //Make updates to VCs if any here.
        }
    }
}

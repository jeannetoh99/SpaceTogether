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
    
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

    override func viewDidLoad() {
        super.viewDidLoad()
        BluetoothDetector.init()

        // Do any additional setup after loading the view.
        print("View has loaded :)")
    }
    
    @IBAction func shieldMeNowButtonPressed(_ sender: UIButton) {
        print("shield me now!")
        self.performSegue(withIdentifier: "HomeToSafeSegue", sender: self)
    }
    
    @IBAction func setMyOwnAlarmButtonPressed(_ sender: UIButton) {
        print("set my own alarm!")
        self.performSegue(withIdentifier: "HomeToRecordSegue", sender: self)
    }

    @IBAction func selectAlarmButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToSelectSegue", sender: self)
    }
    
    func presentBluetoothAlert(_ bluetoothStateString: String) {
                #if DEBUG
                let alert = UIAlertController(title: "Bluetooth Issue: "+bluetoothStateString+" on iOS: "+UIDevice.current.systemVersion, message: "Please screenshot this message and send to support!", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                DispatchQueue.main.async {
                    var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
                    while topController?.presentedViewController != nil {
                        topController = topController?.presentedViewController
                    }

                    topController?.present(alert, animated: true)
                }
                #endif

                #if RELEASE
                let alert = UIAlertController(title: "App restart required for Bluetooth to restart!", message: "Press Ok to exit the app!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    exit(0)
                }))
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
                #endif
            }
    
}

        






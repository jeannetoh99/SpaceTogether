//
//  ViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
        fetchDevicesEncounteredCount()
    }
    
    @objc
    func fetchDevicesEncounteredCount() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Encounter")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["v"]
        fetchRequest.returnsDistinctResults = true
        do {
            let devicesEncountered = try managedContext.fetch(fetchRequest)
            print(devicesEncountered)
            var numberOfDevices = devicesEncountered.count
            if numberOfDevices < 2 {
                self.performSegue(withIdentifier: "HomeToSafeSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "HomeToAlarmSegue", sender: self)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func setMyOwnAlarmButtonPressed(_ sender: UIButton) {
        print("set my own alarm!")
        self.performSegue(withIdentifier: "HomeToRecordSegue", sender: self)
    }

    @IBAction func selectAlarmButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToSelectSegue", sender: self)
    }
    
    @IBAction func saveRecordingAndUnwindAction(unwindSegue: UIStoryboardSegue) {
        // TODO: Save recording before unwinding
    }
    
    func registerForPushNotifications() {
        BlueTraceLocalNotifications.shared.checkAuthorization { (_) in
            //Make updates to VCs if any here.
        }
    }
}

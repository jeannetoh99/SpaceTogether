//
//  SafeViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import CoreData

class SafeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            var deviceNo = self.fetchDevicesEncounteredCount()
            if deviceNo > 1 {
                timer.invalidate()
                self.performSegue(withIdentifier: "SafeToAlarmSegue", sender: self)
            }
        }
    }
    
    
    @objc
    func fetchDevicesEncounteredCount() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 0
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
            return numberOfDevices
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
    
    @IBAction func okThanksButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

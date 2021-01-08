//
//  AlarmViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import CoreData

class AlarmViewController: UIViewController {

    @IBOutlet weak var devicesEncountered: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Encounter>(entityName: "Encounter")
            fetchRequest.includesPropertyValues = false
            do {
                let encounters = try managedContext.fetch(fetchRequest)
                for encounter in encounters {
                    managedContext.delete(encounter)
                }
                try managedContext.save()
            } catch {
                print("Could not perform delete. \(error)")
            }
            var deviceNo = self.fetchDevicesEncounteredCount()
            if deviceNo < 1 {
                timer.invalidate()
                self.performSegue(withIdentifier: "AlarmToSafeSegue", sender: self)
            }
        }
    }
    
    @IBAction func shutupButtonPressed(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Encounter>(entityName: "Encounter")
        fetchRequest.includesPropertyValues = false
        do {
            let encounters = try managedContext.fetch(fetchRequest)
            for encounter in encounters {
                managedContext.delete(encounter)
            }
            try managedContext.save()
        } catch {
            print("Could not perform delete. \(error)")
        }
        self.dismiss(animated: true, completion: nil)
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
}

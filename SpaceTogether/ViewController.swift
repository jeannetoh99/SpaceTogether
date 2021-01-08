//
//  ViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func saveRecordingAndUnwindAction(unwindSegue: UIStoryboardSegue) {
        // TODO: Save recording before unwinding
    }
    
}

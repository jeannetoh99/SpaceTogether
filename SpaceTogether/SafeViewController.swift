//
//  SafeViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit

class SafeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        
        //TODO: Start bluetooth detector
    }
    
    @IBAction func okThanksButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tempButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SafeToAlarmSegue", sender: self)
    }
}

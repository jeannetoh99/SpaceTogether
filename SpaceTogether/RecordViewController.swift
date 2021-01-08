//
//  RecordViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit

class RecordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RecordToRecordingSegue", sender: self)
    }
}

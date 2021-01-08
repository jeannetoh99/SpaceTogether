//
//  RecordingViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit

class RecordingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        
        //TODO: start recording automatically
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        // TODO: stop and save recording
        self.performSegue(withIdentifier: "RecordingToRecordedSegue", sender: self)
    }
}
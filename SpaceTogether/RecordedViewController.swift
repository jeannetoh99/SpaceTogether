//
//  RecordedViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit

class RecordedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        
        // TODO: auto play recording in loop
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RecordedToRecordingSegue", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //TODO: save and choose recorded voice
        self.dismiss(animated: true, completion: nil)
    }
}
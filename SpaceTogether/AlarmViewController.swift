//
//  AlarmViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit

class AlarmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
    }
    
    @IBAction func shutupButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
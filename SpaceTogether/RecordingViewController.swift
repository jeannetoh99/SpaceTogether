//
//  RecordingViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")

        // Load GIF using Name
        let recordingGif = UIImage.gifImageWithName("recording_gap")
        let imageView = UIImageView(image: recordingGif)
        imageView.frame = CGRect(x:0, y:0, width: 250, height: 325)
        imageView.center = view.center
        view.addSubview(imageView)
        
        //TODO: start recording automatically
    }

}

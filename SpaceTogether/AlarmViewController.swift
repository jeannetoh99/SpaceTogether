//
//  AlarmViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import AVFoundation

class AlarmViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        
        do {
            var path:URL!
            if let chosenPath:URL = UserDefaults.standard.url(forKey: "chosenAudioPath") {
                path = chosenPath
            } else {
                let urlString = Bundle.main.path(forResource: "defaultAudio", ofType: "mp3")
                path = NSURL(fileURLWithPath: urlString!) as URL
            }
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        } catch {
            
        }
    }
    
    @IBAction func shutupButtonPressed(_ sender: UIButton) {
        audioPlayer?.stop()
        self.dismiss(animated: true, completion: nil)
    }
}

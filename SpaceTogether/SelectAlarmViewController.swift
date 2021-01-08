//
//  SelectAlarmViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import AVFoundation

class SelectAlarmViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        
        self.buttonsView()
    }
    
    // UIColor(red: 240/255.0, green: 100/255.0, blue: 101/255.0, alpha: 1)
    
    func buttonsView() {
        
        var recordings = [
            recording(name: "Default"),
            recording(name: "First"),
            recording(name: "Second"),
            recording(name: "Third")
        ]
        
        var buttons = [UIButton]()
        var button : UIButton
        
        let UIred = UIColor(red: 202/255.0, green: 63/255.0, blue: 60/255.0, alpha: 1)
        let CGred = CGColor(red: 202/255.0, green: 63/255.0, blue: 60/255.0, alpha: 1)
        let UIdarkRed = UIColor(red: 150/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1)
        let CGdarkRed = CGColor(red: 150/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1)
        
        var y :CGFloat = 0
        for recording in recordings {
            button = UIButton.init(type: UIButton.ButtonType.system) as UIButton
            button.frame = CGRect(x: 0, y: 0, width: 200.0, height: 50.0)
            button.center.x = self.view.center.x
            button.center.y = self.view.center.y - 120 + y
            button.backgroundColor = UIred
            button.layer.cornerRadius = 50
            button.layer.borderWidth = 1
            button.layer.borderColor = CGred
            button.setTitle("\(recording.name)", for: [])
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: UIControl.Event.touchUpInside)
            
            self.view.addSubview(button)
            
            buttons.append( button )
            y = y + 60
        }
        
    }
    
    @objc func buttonAction(sender:UIButton!)
    {
        print("Button tapped")
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    class recording : NSObject {
        var name: String
        
        init(name: String) {
            self.name = name
        }
    }
    
}

//
//  RecordViewController.swift
//  SpaceTogether
//
//  Created by Jeanne Toh Xuan Ning on 8/1/21.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {

    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var numberOfRecords = 0
    var chosenAudio = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded :)")
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission {
            (hasPermission) in
            if hasPermission {
                print("ACCEPTED")
            }
        }
        
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int {
            numberOfRecords = number
        }
        
        if let chosenNumber:Int = UserDefaults.standard.object(forKey: "chosenAudioFile") as? Int {
            chosenAudio = chosenNumber
        }
        
    }
    
    
    @IBAction func record(_ sender: UIButton) {
        
        // Check if we have an active recorder
        if audioRecorder == nil {
            
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // start recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                titleLabel.text = "Recording..."
                
            } catch {
                displayAlert(title: "Oops!", message: "Recording failed")
                titleLabel.text = "Tap to start recording"
                
            }
        } else {
            audioRecorder.stop()
            audioRecorder = nil
            
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            myTableView.reloadData()
            titleLabel.text = "Tap to start recording"
            
        }
    }
    
    // Displays alert
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Gets path to directory to store audio
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    // Sets up table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (indexPath.row == 0) {
            cell.textLabel?.text = "Default Noise"
        } else {
            cell.textLabel?.text = String("Recording \(indexPath.row)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        do {
            var path:URL!
            
            if (indexPath.row == 0) {
                let urlString = Bundle.main.path(forResource: "defaultAudio", ofType: "mp3")
                path = NSURL(fileURLWithPath: urlString!) as URL
            } else {
                path = getDirectory().appendingPathComponent("\(indexPath.row).m4a")
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
            UserDefaults.standard.set(path, forKey: "chosenAudioPath")
            UserDefaults.standard.set(indexPath.row, forKey: "chosenAudioFile")
            
        } catch {
            
        }
        
    }
    
    
}

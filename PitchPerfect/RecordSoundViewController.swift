//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Nora al-mansour on 2/10/1440 AH.
//  Copyright © 1440 Nora al-mansour. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController ,AVAudioRecorderDelegate  {

    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var reocrdingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print ("viewWillAppear is working")
    }

   
    //Recoding:
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordAudio(_ sender: Any) {
        reocrdingLabel.text = "Recording in prosess!"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
     
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
       // print(filePath ?? "/Users/Apple/Desktop")
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self // To tell it can act as a delegate
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    //Stop Recoding:
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBAction func stopRecoding(_ sender: Any) {
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        reocrdingLabel.text = "Tap To record!"
        
         audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
     
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            //The app programmatically triggers a segue from the first scene to the second:
            performSegue(withIdentifier: "stopRecordingSeg", sender: audioRecorder.url)
        } else {
            print ("Usuccessfully Recording")
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSeg"{
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordAudioURL = recordedAudioURL
        }
    }
}


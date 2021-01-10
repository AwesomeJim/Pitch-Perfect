//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by James Mbugua on 06/12/2020.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    let stopRecording = "stopRecording"
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled=false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

  
    // MARK: - Record Audio
    @IBAction func recordAudio(_ sender: Any) {
        configureUi(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    

    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        configureUi(false)
        
    }
    // MARK: - Configure Recording UI State
    func configureUi(_ isRecording:Bool) {
        recordButton.isEnabled = !isRecording // to enable the button
        recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
        stopRecordingButton.isEnabled = isRecording // to disable the button
    }
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        flag ? performSegue(withIdentifier: stopRecording, sender:audioRecorder.url) : print("Recording was not successful")
    }
    
    // MARK: - Navigation segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier==stopRecording{
            let playSoundVC=segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundVC.recordedAudioURL=recordAudioURL
        }
    }
}


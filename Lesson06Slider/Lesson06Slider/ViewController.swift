//
//  ViewController.swift
//  Lesson06Slider
//
//  Created by Orest on 01.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//  ***Audio player***

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player = AVAudioPlayer()
    var timerForSlider = Timer()
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var timeTimerLabel: UILabel!
    @IBOutlet weak var procentVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            if let soundPath = Bundle.main.path(forResource: "gribi", ofType: "mp3") {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
                timeSlider.maximumValue = Float(player.duration)
            }
        } catch {
            print("error")
        }
        
        //timeSlider.isContinuous = false
        
        timeSlider.setThumbImage(UIImage(imageLiteralResourceName: "thumb"), for: .normal)
        
        timerForSlider = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeSlider), userInfo: nil, repeats: true)
        
    }
    
    //timer selector
    @objc func updateTimeSlider() {
        timeSlider.value = Float(player.currentTime)
        
        //set sound timer
        let currentTime = Int(player.currentTime)
        let minutes = currentTime / 60
        let seconds = currentTime - minutes * 60
        
        if seconds < 10 {
            timeTimerLabel.text = "\(minutes):0\(seconds)"
        } else {
            timeTimerLabel.text = "\(minutes):\(seconds)"
        }
    }
    
    //MARK: - Actions
    @IBAction func playButtonAction(_ sender: UIButton) {
        player.play()
    }
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        player.pause()
    }
    @IBAction func stopButtonAction(_ sender: UIButton) {
        player.stop()
        player.currentTime = 0.0
    }
    
    @IBAction func timeSliderAction(_ sender: Any) {
        player.currentTime = TimeInterval(timeSlider.value)
    }

    @IBAction func volumeSliderAction(_ sender: UISlider) {
        player.volume = volumeSlider.value
        
        //show volume procent in label
        let procent = Int(volumeSlider.value * 100)
        procentVolumeLabel.text = "\(procent)%"
    }
}


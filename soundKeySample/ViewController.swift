//
//  ViewController.swift
//  soundKeySample
//
//  Created by Sachin Nautiyal on 8/30/18.
//  Copyright © 2018 Sachin Nautiyal. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    let session = AVAudioSession.sharedInstance()
    var volButtonTimer : Timer?
    var elapsedTimer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sessionPlayback = AVAudioSessionCategoryPlayback
        let sessionOptions = AVAudioSessionCategoryOptions.mixWithOthers
        do {
            try session.setCategory(sessionPlayback, with: sessionOptions)
            try session.setActive(true)
            session.addObserver(self, forKeyPath: "outputVolume", options: [.old, .new], context: nil)
        } catch let error {
            print(error)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        let newVolume = change[.newKey] as? Float ?? 0.0
        let oldVolume = change[.oldKey] as? Float ?? 0.0
        
        if (newVolume > oldVolume) {
            self.onVolumeUp() // Up
        } else {
            //Down
        }
        
    }
    
    // let's say when count is 3 is enough to admit that it was long press
    func onVolumeUp() {
        if let timer = self.volButtonTimer {
            if timer.isValid {
                if(elapsedTimer == 3) {
                    elapsedTimer = 0
                    print("Long") // Do your long task here
                }
                elapsedTimer = elapsedTimer + 1
                self.volButtonTimer?.invalidate()
            }
        }
        self.volButtonTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(self.onTimerFire), userInfo: nil, repeats: false)
    }
    
    @objc func onTimerFire() {
        self.volButtonTimer = nil
        if elapsedTimer != 0 {
            elapsedTimer = 0
        } else {
            print("Short") // Do your short time task here.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



//
//  MusicHelper.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var backgroundPlayer: AVAudioPlayer?
    var buttonPlayer: AVAudioPlayer?
    

    func playBackgroundMusic() {

        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bgmusic", ofType: "mp3")!)
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            backgroundPlayer!.numberOfLoops = -1
            backgroundPlayer!.prepareToPlay()
            backgroundPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
        
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
    
    func playButtonSound() {
        let userDefaults = UserDefaults.standard
        let buttonStatus = userDefaults.value(forKey: "buttonSoundStatus") as? String
        if buttonStatus == "Off" {
            return
        }
        let buttonSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "buttonSound", ofType: "mp3")!)
        do {
            buttonPlayer = try AVAudioPlayer(contentsOf: buttonSound as URL)
            buttonPlayer?.play()
        }
        catch {
            print("Error playing sound")
        }
    }

}


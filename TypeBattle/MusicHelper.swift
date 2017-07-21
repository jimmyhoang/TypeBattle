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
    var audioPlayer: AVAudioPlayer?
    
    
    func playBackgroundMusic() {

        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bgmusic", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
        
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
    
    func playButtonSound() {
        let buttonSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "buttonSound", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: buttonSound as URL)
            audioPlayer?.play()
        }
        catch {
            print("Error playing sound")
        }
    }
}


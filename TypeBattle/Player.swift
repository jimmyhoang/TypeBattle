//
//  Player.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation
import UIKit

class Player {
    
    // Profile properties
    var playerID: String //ID generated by Firebase
    var name: String
    
    // Additional profile properties
    var avatar: UIImage = UIImage()
    var avatarName: String
    
    // Game/stats properties
    var level = 1
    var levelProgression = 0.0
    var matchesWon = 0
    var matchesPlayed = 0
    
    init() {
        self.playerID     = ""
        self.name         = ""
        self.avatarName   = ""
        
        guard let image = UIImage(named: avatarName) else {return}
        avatar = image
    }

    init(name: String,playerID: String,avatarName: String) {
        self.playerID     = playerID
        self.name         = name
        self.avatarName   = avatarName
        
        guard let image = UIImage(named: avatarName) else {return}
        avatar = image
    }
    
    func saveToFirebase() {
        
        //TODO: save player to firebase and get the id
        
    }
    
    func toAnyObject() -> Any {
        return [
            "name"             : name,
            "playerID"         : playerID,
            "level"            : level,
            "levelProgression" : levelProgression,
            "matchesWon"       : matchesWon,
            "matchesPlayed"    : matchesPlayed,
            "avatarName"       : avatarName
        ]
    }
    
    func login() {}
    
    func logout() {}
    
    func changeAvatar() {}
        
    //    var name:String
    //    var uniqueIdentifier:String
    //    var avatar:UIImage
    //    var level:Int
    //    var experience:Double?
    //    var matchesWon:Int?
    //    var matchesPlayed:Int?
    //    var fastestGame:Int?
    //    var perk:String?
    //    var timeFinished:Int?
    //
    //    init(name:String,uniqueIdentifier:String,avatar:UIImage,level:Int) {
    //        self.name             = name
    //        self.uniqueIdentifier = uniqueIdentifier
    //        self.avatar           = avatar
    //        self.level            = level
    //    }
}

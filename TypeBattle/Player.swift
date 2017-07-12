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
    
    var name:String
    var uniqueIdentifier:String
    var avatar:UIImage
    var level:Int
    var experience:Double?
    var matchesWon:Int?
    var matchesPlayed:Int?
    var fastestGame:Int?
    var perk:String?
    var timeFinished:Int?
    
    init(name:String,uniqueIdentifier:String,avatar:UIImage,level:Int) {
        self.name             = name
        self.uniqueIdentifier = uniqueIdentifier
        self.avatar           = avatar
        self.level            = level
    }
}

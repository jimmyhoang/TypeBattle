//
//  GameCharacter.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation

enum GameCharacterType: String {
    case cat = "cat"
    case dog = "dog"
    case knight = "knight"
    case ninjaBoy = "ninjaboy"
    case ninjaGirl = "ninjagirl"
    case robot = "robot"
    case zombieBoy = "zombieboy"
    case zombieGirl = "zombiegirl"
    
    static func stringToEnum(characterType: String) -> GameCharacterType {
        
        switch characterType {
        case "cat":
            return .cat
        case "dog":
            return .dog
        case "knight":
            return .knight
        case "ninjaboy":
            return .ninjaBoy
        case "ninjagirl":
            return .ninjaGirl
        case "robot":
            return .robot
        case "zombieboy":
            return .zombieBoy
        default:
            return .zombieGirl
        }
    }
}

class GameCharacter {
    
    var type: GameCharacterType
    var typeDescription: String
    var perkDescription: String

    init(type: GameCharacterType, typeDescription: String, perkDescription: String) {
        self.type = type
        self.typeDescription = typeDescription
        self.perkDescription = perkDescription
    }
}

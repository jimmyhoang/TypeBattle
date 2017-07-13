//
//  GameCharacter.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation

enum GameCharacterType {
    case cat
    case dog
    case knight
    case ninjaBoy
    case ninjaGirl
    case robot
    case zombieBoy
    case zombieGirl
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

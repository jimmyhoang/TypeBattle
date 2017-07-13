//
//  PlayerSession.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation

class PlayerSession {
    
    var playerID: String
    var currentPostion: Int
    var gameCharacter: GameCharacterType
    var totalTime: Int
    
    init(playerID: String, currentPosition: Int, gameCharacter: GameCharacterType) {
        self.playerID = playerID
        self.currentPostion = currentPosition
        self.gameCharacter = gameCharacter
        self.totalTime = 0
    }

}

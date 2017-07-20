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
    var playerName: String
    var currentIndex: Int
    var gameCharacter: GameCharacterType
    var totalTime: Int
    var isReady: Bool
    var finalPosition: Int?
    
    init(playerID: String, playerName: String) {
        self.playerID = playerID
        self.playerName = playerName
        self.currentIndex = 0
        self.gameCharacter = .cat
        self.totalTime = 0
        self.isReady = false
    }
    
    init(playerID: String, playerName: String, currentIndex: Int, gameCharacter: GameCharacterType, isReady: Bool) {
        self.playerID = playerID
        self.playerName = playerName
        self.currentIndex = currentIndex
        self.gameCharacter = gameCharacter
        self.totalTime = 0
        self.isReady = isReady
    }
    
    func createDictionary() -> Dictionary<String, Any> {
        
        var dictionary = Dictionary<String, Any>()
        
        dictionary["id"] = self.playerID
        dictionary["nm"] = self.playerName
        dictionary["ix"] = self.currentIndex
        dictionary["ch"] = self.gameCharacter.rawValue
        dictionary["st"] = self.isReady
        
        return dictionary
        
    }
    
    class func convertToPlayerSession(dictionary: Dictionary<String, Any>) -> PlayerSession? {
        
        // Get values
        guard let playerID = dictionary["id"] as? String,
                let playerName = dictionary["nm"] as? String,
                let currentIndex = dictionary["ix"] as? Int,
                let gameCharacter = dictionary["ch"] as? String,
                let isReady = dictionary["st"] as? Bool else {
            print("Error parsing dictionary to PlayerSession")
            return nil
        }
        
        return PlayerSession(playerID: playerID, playerName: playerName, currentIndex: currentIndex, gameCharacter: GameCharacterType.stringToEnum(characterType: gameCharacter), isReady: isReady)
    }

}

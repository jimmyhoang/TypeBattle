//
//  GameManager.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase

class GameManager {
    
    func createGameLobby(name: String, keyword: String, maxCapacity: Int, location: CLLocation?, owner: Player) -> GameLobby {
        
        return GameLobby(name: name, textCategory: keyword, capacity: maxCapacity, owner: owner, location: location)
    }
    
    func createGameSession(lobby: GameLobby, someRandomText: String, persistInFirebase: Bool) -> GameSession {
        
        // Use GameLobby data to create a GameSession
        let session = GameSession(name: lobby.name, gameText: someRandomText, capacity: lobby.capacity, ownerID: lobby.owner.playerID, location: lobby.location)
        
        session.players.append(PlayerSession(playerID: lobby.owner.playerID, playerName: lobby.owner.name))
        
        // Persist in Firebase
        if(persistInFirebase) {
            session.saveToFirebase()
        }
        
        return session
    }
    
    func addPlayerToGame (gameSessionID: String, player: Player) {
        
        // add PlayerSession to Firebase
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSessionID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in

            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }

            // if the user is already in the game, does not add it again
            for p in gameSession.players {
                if(p.playerID == player.playerID) {
                    return
                }
            }
            
            // create a playersession and add to the gamesession
            let playerSession = PlayerSession(playerID: player.playerID, playerName: player.name)
            gameSession.players.append(playerSession)
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
        })
    }
    
    func removePlayerOfGame (gameSessionID: String, player: Player) {
        
        // add PlayerSession to Firebase
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSessionID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // if the user is already in the game, does not add it again
            for i in 0...gameSession.players.count {
                if(gameSession.players[i].playerID == player.playerID) {
                    gameSession.players.remove(at: i)
                    break
                }
            }
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
        })
    }

    func setPlayerReady (gameSessionID: String, playerID: String, characterType: GameCharacterType, isReady: Bool) {
        
        // change game session status to Started
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSessionID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // change status for player
            for player in gameSession.players {
                
                if(player.playerID == playerID) {
                    
                    player.isReady = isReady
                    player.gameCharacter = characterType
                }
            }
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
        })
    }
    
    func startGameSession (gameSessionID: String) {
        
        // change game session status to Started
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSessionID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // change status
            gameSession.status = .started
            
            // create "light" struct to control players data during game (for performance)
            let ref2 = Database.database().reference(withPath: "players_sessions")
            let playersRef = ref2.child(gameSessionID)
            
            for p in gameSession.players {
                
                // change every player to Ready status
                p.isReady = true
                
                // populate PlayerSession data with initial position
                let playerRef = playersRef.child(p.playerID)
                let playerDict = ["nm": p.playerName, "ix": 0, "pct": 0.0] as [String : Any]
                playerRef.setValue(playerDict)
            }
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
        })

    }
    
    func finishGameSession (gameSession: GameSession) {
        
        // change game session status to finished
        gameSession.status = .finished
        
        // save gamesession to firebase
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSession.gameSessionID)
        gameRef.setValue(gameSession.createDictionary())
        
        // increment matches won/played for each player
        for ps in gameSession.players {
        
            NetworkManager.fetchPlayerDetails(playerID: ps.playerID, withCompletionBlock: { (pl) in
                pl.matchesPlayed += 1
                
                if(ps.finalPosition == 1) {
                    pl.matchesWon += 1
                    
                    var needed = 0
                    for i in 0...pl.level {
                        needed += i
                    }
                    
                    pl.level = (pl.matchesWon == needed ) ? pl.level + 1: pl.level
                }
            })
        }
    }
    
    func playerCompletedGame (gameSessionID: String, playerID: String, totalTime: Double) {
        
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSessionID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // Finish game
            gameSession.status = .finished
            
            // Create property to store current player
            var currentPlayer = PlayerSession(playerID: "", playerName: "")
            var nextPosition = 1
            
            for player in gameSession.players {
                
                // find player
                if(player.playerID == playerID) {
                    currentPlayer = player
                }
                
                // check players that already finished the game
                if(player.finalPosition != 0) {
                    nextPosition += 1
                }
            }
            
            currentPlayer.finalPosition = nextPosition
            currentPlayer.totalTime = totalTime
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
        })
    }
    
    func cancelGameSession (gameSessionID: String) {
        
        Database.database().reference(withPath: "game_sessions").child(gameSessionID).removeValue()
    }
    
    func incrementPosition (gameSessionID: String, player: Player, index: Int, progress: Double) {
        
        let ref = Database.database().reference(withPath: "players_sessions").child(gameSessionID).child(player.playerID)
        
        let dictionary = ["nm": player.name,
                          "ix": index,
                          "pct": progress] as [String : Any]
        
        ref.setValue(dictionary)
    }
    
    func listAvailableGameSessions(withCompletionBlock block: @escaping (GameSession, String) -> Swift.Void) {
    
        let ref = Database.database().reference(withPath: "game_sessions")
        ref.observe(.childAdded, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // check session status
            if(gameSession.status == .waitingForPlayers && gameSession.capacity > 1) {
                block(gameSession, "added")
            }
        })
        
        ref.observe(.childChanged, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // check session status
            if(gameSession.status == .waitingForPlayers && gameSession.capacity > 1) {
                block(gameSession, "updated")
            }
        })

        ref.observe(.childRemoved, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // check session status
            if(gameSession.status == .waitingForPlayers && gameSession.capacity > 1) {
                block(gameSession, "deleted")
            }
        })

    
    }
    
    func observeLeaderboardChanges(gameSessionID: String, withCompletionBlock block: @escaping (Array<Array<Any>>) -> Swift.Void) {
        
        let ref = Database.database().reference(withPath: "players_sessions").child(gameSessionID)
        ref.observe(.value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            var playersArray = Array<Array<Any>>()
            
            for key in sessionDictionary.keys {
                
                let playerID = key //PlayerID
                
                let subDictionary = sessionDictionary[playerID] as? [String: Any] ?? [:]
                let name = subDictionary["nm"] as! String
                let index = subDictionary["ix"] as! Int
                let percentage = subDictionary["pct"] as! Double
                
                playersArray.append([playerID, name, index, percentage])
            }
            
            block(playersArray)
        })

    }
    
    func getAllCharacters() -> Array<GameCharacter> {
        
        //TODO: Maybe we should get them from firebase in the future...
        var allTypes = Array<GameCharacter>()
        
        allTypes.append(GameCharacter(type: .cat,
                                      typeDescription: "Cat comes from a family of dogs.",
                                      perkDescription: ""))
        
        allTypes.append(GameCharacter(type: .dog,
                                      typeDescription: "Dog comes from a family of cats.",
                                      perkDescription: ""))
        
        allTypes.append(GameCharacter(type: .knight,
                                      typeDescription: "The warrior has battled through multiple wars to defend the origami mommy.",
                                      perkDescription: ""))
        
        allTypes.append(GameCharacter(type: .robot,
                                      typeDescription: "Robot comes from the year 3678 in search of the origami mommy. ",
                                      perkDescription: ""))
        
        allTypes.append(GameCharacter(type: .ninjaBoy,
                                      typeDescription: "Ninja Boy is a ninja, but a boy.",
                                      perkDescription: ""))
        
        allTypes.append(GameCharacter(type: .ninjaGirl,
                                      typeDescription: "Ninja Girl is a ninja, but a girl.",
                                      perkDescription: ""))
        
        allTypes.append(GameCharacter(type: .zombieBoy,
                                      typeDescription: "Zombie Boy is a zombie who was a boy.",
                                      perkDescription: ""))
        
        allTypes.append(GameCharacter(type: .zombieGirl,
                                      typeDescription: "Zombie Girl is a zombie who was a girl.",
                                      perkDescription: ""))
        
        return allTypes
    }

}

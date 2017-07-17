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
    
    func createGameLobby(name: String, keyword: String, maxCapacity: Int, location: CLLocation?) -> GameLobby {
        
        //TODO: Get playerID from logged user
        let ownerID = "OwnerID"
        
        return GameLobby(name: name, textCategory: keyword, capacity: maxCapacity, ownerID: ownerID, location: location)
    }
    
    
    func createGameSession(lobby: GameLobby) -> GameSession {
        
        // Use GameLobby data to create a GameSession
        let session = GameSession(name: lobby.name, gameText: generateRamdomText(keyword: lobby.textCategory), capacity: lobby.capacity, ownerID: lobby.ownerID, location: lobby.location)
        
        session.players.append(PlayerSession(playerID: "OwnerID", playerName: "OwnerName"))
        
        // Persist in Firebase
        session.saveToFirebase()
        
        return session
    }
    
    
    func addPlayerToGame (gameSessionID: String, playerID: String, playerName: String) {
        
        // add PlayerSession to Firebase
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSessionID)
        gameRef.observe(.value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // create a playersession and add to the gamesession
            let playerSession = PlayerSession(playerID: playerID, playerName: playerName)
            gameSession.players.append(playerSession)
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
        })
    }
    
    func setPlayerReady (gameSessionID: String, playerID: String) {
        
    }
    
    func startGameSession (gameSessionID: String) {
        
        changeGameSessionStatus(gameSessionID: gameSessionID, status: .started)
    }
    
    func finishGameSession (gameSessionID: String) {
        
        changeGameSessionStatus(gameSessionID: gameSessionID, status: .finished)
    }
    
    private func changeGameSessionStatus (gameSessionID: String, status: GameSessionStatus) {
        
        // change game session status to Started
        let ref = Database.database().reference(withPath: "game_sessions")
        let gameRef = ref.child(gameSessionID)
        gameRef.observe(.value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // change status
            gameSession.status = status
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
            
            gameRef.removeAllObservers()
        })

    }
    
    func listAvailableGameSessions(withCompletionBlock block: @escaping (GameSession) -> Swift.Void) {
    
        let ref = Database.database().reference(withPath: "game_sessions")
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            
            // check session status
            if(gameSession.status == .waitingForPlayers) {
                block(gameSession)
            }
        })
    
    }
    
    func generateRamdomText(keyword: String) -> String {
        
        //TODO: Call NetworkManager and get random text from API
        return "The quick brown fox jumps over the lazy dog The quick brown fox jumps over the lazy dog The quick brown fox jumps over the lazy dog"
        
    }
    
    func getAllCharacters() -> Array<GameCharacter> {
        
        //TODO: Maybe we should get them from firebase in the future...
        var allTypes = Array<GameCharacter>()
        
        allTypes.append(GameCharacter(type: .cat,
                                      typeDescription: "The cat can type really fast when it feels attacked",
                                      perkDescription: "ACTIVE: Randomly changes next 10 letters between upper/lower case for all other players"))
        
        allTypes.append(GameCharacter(type: .dog,
                                      typeDescription: "The dog is a natural typer. Good for beginners",
                                      perkDescription: "ACTIVE: Randomly changes next 10 letters positions for all other players"))
        
        allTypes.append(GameCharacter(type: .knight,
                                      typeDescription: "Warrior typers are very dangerous and feared by all enemies",
                                      perkDescription: "ACTIVE: Send all others players 5 positions back"))
        
        allTypes.append(GameCharacter(type: .robot,
                                      typeDescription: "Sometimes this robot can teleport and time travel",
                                      perkDescription: "PASSIVE: Skip 8 letters"))
        
        allTypes.append(GameCharacter(type: .ninjaBoy,
                                      typeDescription: "Ninja Boy. Where is he?",
                                      perkDescription: "PASSIVE: Allows you to type uppercase letters as lowercase"))
        
        allTypes.append(GameCharacter(type: .ninjaGirl,
                                      typeDescription: "Never underestimate a Ninja Girl. Typing is her main weapon",
                                      perkDescription: "PASSIVE: Allows you to skip spaces in the text"))
        
        allTypes.append(GameCharacter(type: .zombieBoy,
                                      typeDescription: "Typing Dead...",
                                      perkDescription: "ACTIVE: Hide part of the text for all other players"))
        
        allTypes.append(GameCharacter(type: .zombieGirl,
                                      typeDescription: "Typing Dead...",
                                      perkDescription: "PASSIVE: Skip 2 words"))
        
        return allTypes
    }

}

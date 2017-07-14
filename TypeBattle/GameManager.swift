//
//  GameManager.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation

class GameManager {
    
    
    func createGameSession (lobby: GameLobby) {
        let session = GameSession(name: lobby.name, gameText: generateRamdomText(keyword: lobby.textCategory), capacity: lobby.capacity)
        session.saveToFirebase()
    }
    
    
    func addPlayerToGame (gameSessionID: String, playerID: String, gameCharacter: GameCharacterType) {
        
        //TODO: when a user chooses a room, create a playersession and add to the session
        
    }
    
    func startGameSession (gameSessionID: String) {
        
    }
    
    func finishGameSession (gameSessionID: String) {
        
    }
    
    func listAvailableRooms() {
    
        //TODO: List all GameSession rooms with waitingForPlayers status
    
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

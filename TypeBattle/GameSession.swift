//
//  GameSession.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation

enum GameSessionStatus: String {
    case waitingForPlayers = "waiting"
    case started = "started"
    case finished = "finished"
}

class GameSession {

    var gameSessionID: String //ID generated by Firebase
    var name: String
    var ownerID: String // PlayerID of the user who created the room
    var gameText: String
    var capacity: Int
    var players: [PlayerSession]
    var status: GameSessionStatus
    var location: CLLocation?
    
    init(name: String, gameText: String, capacity: Int, ownerID: String, location: CLLocation?) {
        self.gameSessionID = ""
        self.name = name
        self.gameText = gameText
        self.capacity = capacity
        self.players = [PlayerSession]()
        self.status = .waitingForPlayers
        self.ownerID = ownerID
        self.location = location
    }
    
    init(sessionID: String, name: String, gameText: String, capacity: Int, ownerID: String, status: GameSessionStatus, location: CLLocation?) {
        self.gameSessionID = sessionID
        self.name = name
        self.gameText = gameText
        self.capacity = capacity
        self.players = [PlayerSession]()
        self.status = status
        self.ownerID = ownerID
        self.location = location
    }

    
    func saveToFirebase() {
        // Create a reference to Firebase Database
        let firebaseRef = Database.database().reference(withPath: "game_sessions")
        
        // create a game session
        let gameRef = firebaseRef.childByAutoId()
        self.gameSessionID = gameRef.key
        gameRef.setValue(self.createDictionary())
    }
    
    func startGameSession() {
        
        self.status = .started
        
    }
    
    func finishGameSession() {
        
        self.status = .finished
        
    }
    
    func createDictionary() -> Dictionary<String, Any> {
        
        var dictionary = Dictionary<String, Any>()
        
        dictionary["sessionID"] = self.gameSessionID
        dictionary["name"] = self.name
        dictionary["text"] = self.gameText
        dictionary["capacity"] = self.capacity
        dictionary["status"] = self.status.rawValue
        dictionary["ownerID"] = self.ownerID
        
        if let location = self.location {
            dictionary["location"] = ["latitude":location.coordinate.latitude, "longitude": location.coordinate.longitude]
        }
        
        
        if(self.players.count > 0) {
            dictionary["players"] = self.createPlayersArray()
        }
        
        return dictionary
    }
    
    func createPlayersArray() -> Array<Any> {
        var array = Array<Any>()
        
        for player in self.players {
            array.append(player.createDictionary())
        }
        return array
    }
    
    class func setPlayerAsReady (gameSessionID: String, playerID: String, characterType: GameCharacterType, isReady: Bool) {
        
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
    
    class func changeGameSessionStatus(gameSessionID: String, status: GameSessionStatus) {
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
            gameSession.status = status
            
            // change every player to Ready status
            if(status == .started) {
                for p in gameSession.players {
                    p.isReady = true
                }
            }
            
            // persist in firebase
            gameRef.setValue(gameSession.createDictionary())
        })

    }
    
    class func cancelGameSession(gameSessionID: String) {
        
        Database.database().reference(withPath: "game_sessions").child(gameSessionID).removeValue()
    }
    
    // Convert data from Firebase
    class func convertToGameSession(dictionary: Dictionary<String, Any>) -> GameSession? {
        
        // Get common values
        guard   let sessionID = dictionary["sessionID"] as? String,
                let name = dictionary["name"] as? String,
                let text = dictionary["text"] as? String,
                let capacity = dictionary["capacity"] as? Int,
                let ownerID = dictionary["ownerID"] as? String,
                let status = dictionary["status"] as? String else {
            print("Error parsing dictionary to GameSession")
            return nil
        }
        
        // Check if location exists
        let location: CLLocation?
        if let locationDictionary = dictionary["location"] as? Dictionary<String, Double> {
            guard let latitude = locationDictionary["latitude"], let longitude = locationDictionary["longitude"] else {
                print ("could not retrieve game session location")
                return nil
            }
            location = CLLocation(latitude: Double(latitude), longitude: Double(longitude))
        }
        else
        {
            location = nil
        }
        
        // Create a GameSession object
        let gameSession = GameSession(sessionID: sessionID, name: name, gameText: text, capacity: capacity, ownerID: ownerID, status: GameSessionStatus.init(rawValue: status)!, location: location)
        
        // Check for players array in json structure
        if let playersArray = dictionary["players"] as? Array<Dictionary<String, Any>> {
            
            for playerJson in playersArray {
                gameSession.players.append(PlayerSession.convertToPlayerSession(dictionary: playerJson)!)
            }
        }
        
        return gameSession
    }
}

//
//  GameLobby.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation
import CoreLocation

// This class was created to hold a new game room settings. Doesn't need to be persisted in firebase. When a room is created, part of the data will be copied to GameSession object
class GameLobby {
    
    var name: String
    var capacity: Int
    var textCategory: String
    var owner: Player // user who created the room
    var location: CLLocation?
    
    init(name: String, textCategory: String, capacity: Int, owner: Player, location: CLLocation?) {
        self.name = name
        self.capacity = capacity
        self.textCategory = textCategory
        self.owner = owner
        self.location = location
    }
    
}

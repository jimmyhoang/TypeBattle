//
//  Character.swift
//  TypeBattle
//
//  Created by Harry Li on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation
import SpriteKit

class Character {

    enum selectedChar {
        case cat, dog, knight, robot, ninjaBoy, ninjaGirl, zombieGirl, zombieBoy
    }
    
    class func selectedCharString(char: selectedChar) -> String{
        switch char {
        case .cat:
            return "cat"
        case .dog:
            return "dog"
        case .knight:
            return "knight"
        case .robot:
            return "robot"
        case .ninjaBoy:
            return "ninjaBoy"
        case .ninjaGirl:
            return "ninjaGirl"
        case .zombieBoy:
            return "zombieBoy"
        case .zombieGirl:
            return "zombieGirl"
        }
    }
    
    enum actionType {
        case idle, run
    }
    
    func characterAnimation(player: SKSpriteNode,char: selectedChar, action: actionType) {
        
        switch char {
        case .cat:
            let ninjaBoyAtlas = SKTextureAtlas(named: "ninjaBoy")
            
            switch action {
            case .idle:
                let ninjaBoyIdleFrames = [
                    ninjaBoyAtlas.textureNamed("Idle__000"),
                    ninjaBoyAtlas.textureNamed("Idle__001"),
                    ninjaBoyAtlas.textureNamed("Idle__002"),
                    ninjaBoyAtlas.textureNamed("Idle__003"),
                    ninjaBoyAtlas.textureNamed("Idle__004"),
                    ninjaBoyAtlas.textureNamed("Idle__005"),
                    ninjaBoyAtlas.textureNamed("Idle__006"),
                    ninjaBoyAtlas.textureNamed("Idle__007"),
                    ninjaBoyAtlas.textureNamed("Idle__008"),
                    ninjaBoyAtlas.textureNamed("Idle__009")
                ]
                
                let idleAction = SKAction.animate(with: ninjaBoyIdleFrames, timePerFrame: 0.12)
                let ninjaBoyIdle = SKAction.repeatForever(idleAction)
                
                player.run(ninjaBoyIdle)
                break
                
            case .run:
                let ninjaBoyRunFrames = [
                    ninjaBoyAtlas.textureNamed("Run__000"),
                    ninjaBoyAtlas.textureNamed("Run__001"),
                    ninjaBoyAtlas.textureNamed("Run__002"),
                    ninjaBoyAtlas.textureNamed("Run__003"),
                    ninjaBoyAtlas.textureNamed("Run__004"),
                    ninjaBoyAtlas.textureNamed("Run__005"),
                    ninjaBoyAtlas.textureNamed("Run__006"),
                    ninjaBoyAtlas.textureNamed("Run__007"),
                    ninjaBoyAtlas.textureNamed("Run__008"),
                    ninjaBoyAtlas.textureNamed("Run__009")
                ]
                
                let runAction = SKAction.animate(with: ninjaBoyRunFrames, timePerFrame: 0.05)
                let ninjaBoyRun = SKAction.repeatForever(runAction)
                
                player.run(ninjaBoyRun)
                break
                
                
            }
        default:
            print("error")
            break
        }
    }
}


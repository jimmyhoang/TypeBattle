//
//  CharacterAnimation.swift
//  TypeBattle
//
//  Created by Harry Li on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import SpriteKit

enum actionType {
    case idle, run
}

class CharacterAnimation {
    
    class func selectedCharString(selectedChar: GameCharacterType) -> String{
        switch selectedChar {
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
    
    class func doAction(player: SKSpriteNode,char: GameCharacterType, action: actionType) {
        
        //check which action it is
        func actionAnimated(selectedAction: actionType) {
            switch selectedAction{
            case .idle:
                animateAction(action: "Idle", duration: 0.12)
                break
            case .run:
                animateAction(action: "Run", duration: 0.08)
                break
            }
        }
        
        //animate selected action
        func animateAction(action: String, duration: Double) {
            let charAtlas = SKTextureAtlas(named: selectedCharString(selectedChar: char))
            var charFrames:[SKTexture] = []
            let textureNames = charAtlas.textureNames
            let sortedTextureNames = textureNames.sorted(by: <)
            
            for i in 0..<sortedTextureNames.count{
                if sortedTextureNames[i].contains(action) {
                    charFrames.append(charAtlas.textureNamed(sortedTextureNames[i]))
                }
            }
            let action = SKAction.animate(with: charFrames, timePerFrame: duration)
            let actionAnimated = SKAction.repeatForever(action)
            
            player.run(actionAnimated)
        }
        
        //animated actions for all characters
        switch char {
        case .cat:
            actionAnimated(selectedAction: action)
            break
        case .dog:
            actionAnimated(selectedAction: action)
            break
        case .knight:
            actionAnimated(selectedAction: action)
            break
        case .robot:
            actionAnimated(selectedAction: action)
            break
        case .ninjaBoy:
            if action == .idle {
                actionAnimated(selectedAction: action)
                player.size = CGSize (width: 70, height: 120)
            } else {
                actionAnimated(selectedAction: action)
                player.size = CGSize (width: 100, height: 120)
            }
            break
        case .ninjaGirl:
            if action == .idle {
                actionAnimated(selectedAction: action)
                player.size = CGSize (width: 70, height: 120)
            } else {
                actionAnimated(selectedAction: action)
                player.size = CGSize (width: 90, height: 120)
            }
            break
        case .zombieBoy:
            actionAnimated(selectedAction: action)
            break
        case .zombieGirl:
            actionAnimated(selectedAction: action)
            break
        }
    }
}

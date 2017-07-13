//
//  GameScene.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        addPlayer()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //MARK: addPlayer
    
    func addPlayer() {
        player = SKSpriteNode()
//        player.texture = SKTexture(imageNamed: Character.selectedCharString(char: Character.selectedChar.cat))
        let scaling = CGSize(width: 150, height: 200)
        player.aspectFillToSize(fillSize: scaling)
        
        player.position = CGPoint(x: 0, y: 0)
        
        self.addChild(player)
    }
    
    //MARK: playerAnimation
    
    func playerAnimation() {
        
    }
}

extension SKSpriteNode {

func aspectFillToSize(fillSize: CGSize) {
    
    if texture != nil {
        self.size = texture!.size()
        
        let verticalRatio = fillSize.height / self.texture!.size().height
        let horizontalRatio = fillSize.width /  self.texture!.size().width
        
        let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio
        
        self.setScale(scaleRatio)
    }
}

}

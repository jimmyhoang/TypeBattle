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

    
    var players: [PlayerSession]!
//    var mainPlayer: PlayerSession!
    
    //test
    let mainPlayer = PlayerSession(playerID: "123", currentPosition: 1, gameCharacter: .cat)
    //
    
    let mainPlayerNode = SKSpriteNode()
    let mainPlayerSize = CGSize(width: 150, height: 200)
    let mainPlayerPosition = CGPoint(x: 200, y: 200)

    var sky: SKSpriteNode!
    var ground: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.zero
        setupBackground()
        setupMainPlayer()
        
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
    
    //MARK: Main Player Setup
    
    func setupMainPlayer() {
        addPlayer(player: mainPlayer, spriteNode: mainPlayerNode)
        mainPlayerNode.zPosition = 10
        CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .run)
    }
    
    
    //MARK: Add Player to Scene
    func addPlayer(player: PlayerSession, spriteNode: SKSpriteNode) {
        //if mainPlayer
//        let spriteSize = mainPlayerSize
//        spriteNode.aspectFillToSize(fillSize: spriteSize)
        spriteNode.size = mainPlayerSize
        spriteNode.position = mainPlayerPosition
        //else other players
        //otherplayer sizes

        self.addChild(spriteNode)
    }
    
    //MARK: Background Setup
    func setupBackground() {
        backgroundColor = UIColor.gameBlue
        setupGround()
        setupSky()
    }
    
    func setupGround() {
        ground = SKSpriteNode()
        ground.texture = SKTexture(imageNamed: "ground")
        ground.anchorPoint = CGPoint.zero
        ground.position = CGPoint.zero
        ground.size = CGSize(width: self.frame.size.width , height: 200)
        addChild(ground)
    }
    
    func setupSky() {
        sky = SKSpriteNode()
        sky.texture = SKTexture(imageNamed: "sky")
        sky.anchorPoint = CGPoint.zero
        sky.position = CGPoint(x: 0, y: 200)
        sky.size = CGSize(width: self.frame.size.width * 2, height: 400)
        addChild(sky)
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

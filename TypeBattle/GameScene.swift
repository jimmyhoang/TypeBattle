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

    //Scene
    var sceneHeight: CGFloat!
    var sceneWidth: CGFloat!
    
    //
    var players: [PlayerSession]!
//    var mainPlayer: PlayerSession!
    
    //test player
    let mainPlayer = PlayerSession(playerID: "123", playerName: "SAM")
    //
    
    //MainPlayer
    let mainPlayerNode = SKSpriteNode()
    let mainPlayerSize = CGSize(width: 150, height: 200)
    let mainPlayerPosition = CGPoint(x: 200, y: 200)

    //Background
    var sky: SKSpriteNode!
    var ground: SKSpriteNode!
    
    //Text
    let textArray = ["a", "p", "p", "l", "e", " ", "h", "i","a", "p", "p", "l", "e", " ", "h", "i","a", "p", "p", "l", "e", " ", "h", "i"]
    var textNode: SKLabelNode!
    var textContainerNode: SKSpriteNode!
    var arrayIndex = 0

    //Camera
    var cam: SKCameraNode!
    
    override func didMove(to view: SKView) {
        //test
        mainPlayer.gameCharacter = .knight
        //
        
        self.anchorPoint = CGPoint.zero
        sceneHeight = self.frame.size.height
        sceneWidth = self.frame.size.width
        setupBackground()
        setupMainPlayer()
        setupCamera()
        setupText()
        detectKeystroke()
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
        
//        cam.position.x = mainPlayerNode.position.x
        
//        cam.position = mainPlayerNode.position
        
    }
    
    //MARK: Players
    
    //Setup mainPlayer
    func setupMainPlayer() {
        addPlayer(player: mainPlayer, spriteNode: mainPlayerNode)
        mainPlayerNode.zPosition = 10
        CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .idle)
    }
    
    //Move mainPlayer
    func moveMainPlayer() {
        let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 0)
        mainPlayerNode.run(moveRight)
    }
    
    
    //Add a player to scene
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
    
    //MARK: Background
    
    //Setup
    func setupBackground() {
        backgroundColor = UIColor.gameBlue
        setupGround()
        setupSky()
    }
    
    
    //Ground
    func setupGround() {
        ground = SKSpriteNode()
        ground.texture = SKTexture(imageNamed: "ground")
        ground.anchorPoint = CGPoint.zero
        ground.position = CGPoint.zero
        ground.size = CGSize(width: self.frame.size.width , height: 200)
        addChild(ground)
    }
    
    
    //Sky
    func setupSky() {
        sky = SKSpriteNode()
        sky.texture = SKTexture(imageNamed: "sky")
        sky.anchorPoint = CGPoint.zero
        sky.position = CGPoint(x: 0, y: 200)
        sky.size = CGSize(width: self.frame.size.width * 2, height: 400)
        addChild(sky)
    }
    
    //MARK: Text
    
    //Setup
    func setupText() {
        textContainerNode = SKSpriteNode()
        textContainerNode.color = UIColor.gameTeal
        textContainerNode.anchorPoint = CGPoint.zero
        textContainerNode.position = CGPoint(x: 0 - cam.position.x, y: 0 + cam.position.y - 150)

        textContainerNode.zPosition = 10
        cam.addChild(textContainerNode)

        var space: CGFloat = 0
        for char in textArray {
            textNode = SKLabelNode(fontNamed: "Supersonic Rocketship")
            textNode.text = char
            textNode.fontSize = 40
            textNode.fontColor = UIColor.gameRed
            textNode.position = CGPoint(x: textNode.frame.width/2 + space, y: 0)
            textNode.zPosition = 10
            textContainerNode.addChild(textNode)
            space += 50.0
        }
        
        textContainerNode.size = CGSize(width: CGFloat(textArray.count) * (textNode.frame.width/2 + 50.0), height: textNode.frame.height)
        
        //DEBUG
        print(textContainerNode.position)
    }
    
//    func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
//        
//        // Determine the font scaling factor that should let the label text fit in the given rectangle.
//        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
//        
//        // Change the fontSize.
//        labelNode.fontSize *= scalingFactor
//        
//        // Optionally move the SKLabelNode to the center of the rectangle.
//        labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
//    }
    
    
    //Moving Text
    func moveText() {
        let moveLeft = SKAction.moveBy(x: -50, y: 0, duration: 0)
        textContainerNode.run(moveLeft)
    }
    
    //Detect user entered text
    func detectKeystroke() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserText(sender:)), name: NSNotification.Name.UITextFieldTextDidChange , object: nil)
    }
    
    //Check user entered text with game text
    func checkUserText(sender: Notification) {
        let textField = sender.object as! UITextField
        let lowerText = textField.text?.lowercased()
        textField.text = ""
        
        if lowerText == textArray[arrayIndex] {
            moveText()
            moveMainPlayer()
            CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .run)
            arrayIndex += 1
        }
    }
    
    //MARK: Camera

    //Setup
    func setupCamera() {
        
        cam = SKCameraNode()
        
        cam.position = CGPoint(x: self.anchorPoint.x + sceneWidth/2, y: self.anchorPoint.y + sceneHeight/2)
        
        self.camera = cam
        addChild(cam)
        
        //DEBUG
        print(cam.position)
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

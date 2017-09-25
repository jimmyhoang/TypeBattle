//
//  BackgroundScene.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-19.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//


import SpriteKit
import GameplayKit


protocol BGSceneDelegate: class {
    func animationDidFinish()
}

class BackgroundScene: SKScene {
    
    //Delegate
    weak var bgDelegate:BGSceneDelegate?
    
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
    let mainPlayerSize = CGSize(width: 120, height: 150)
    let mainPlayerPosition = CGPoint(x: 50, y: 150)
    var playerMovement: CGFloat = 20.0
    var isIdle: Bool!
    
    //Background
    var ground: SKSpriteNode!
    
    var sky: SKSpriteNode!
    let skyYPos: CGFloat = 100.0
    var skyWidth: CGFloat!
    
    //Text
    var textArray: [String]!
    var textNode: SKLabelNode!
    var textContainerNode: SKSpriteNode!
    var arrayIndex = 0
    let spaceBetweenLetters: CGFloat = 25
    var textNodeWidth: CGFloat!
    
    //Camera
    var cam: SKCameraNode!
    
    //Timer
    var timerTextNode: SKLabelNode!
    var initialTime: TimeInterval!
    var timerTime: TimeInterval!
    var firstFrame = true
    
    override func sceneDidLoad() {
        playerMovement = self.frame.size.width+50.0
        NotificationCenter.default.addObserver(self, selector: #selector(🚶🏿🔥(sender:)), name: NSNotification.Name(rawValue:"startAnimation"), object: nil)
    }
    
    @objc func 🚶🏿🔥 (sender: Notification) {
        let moveRight = SKAction.moveBy(x: playerMovement, y: 0, duration: 1.0)
        mainPlayerNode.run(moveRight, completion: {
            self.bgDelegate?.animationDidFinish()
        })
    }
    
    override func didMove(to view: SKView) {
        let app    = UIApplication.shared.delegate as! AppDelegate
        let player = app.player
        
        switch player.avatarName {
        case "cat/Idle (1)":
            mainPlayer.gameCharacter = .cat
        case "dog/Idle (1)":
            mainPlayer.gameCharacter = .dog
        case "knight/Idle (1)":
            mainPlayer.gameCharacter = .knight
        case "ninjaBoy/Idle__000":
            mainPlayer.gameCharacter = .ninjaBoy
        case "ninjaGirl/Idle__000":
            mainPlayer.gameCharacter = .ninjaGirl
        case "robot/Idle (1)":
            mainPlayer.gameCharacter = .robot
        case "zombieBoy/Idle (1)":
            mainPlayer.gameCharacter = .zombieBoy
        case "zombieGirl/Idle (1)":
            mainPlayer.gameCharacter = .zombieGirl
        default:
            mainPlayer.gameCharacter = .knight
        }
        
        self.anchorPoint = CGPoint.zero
        sceneHeight = self.frame.size.height
        sceneWidth = self.frame.size.width
        setupBackground()
        setupMainPlayer()
        
        let moveToPosition = SKAction.moveBy(x: 100, y: 0, duration: 1.0)
        mainPlayerNode.run(moveToPosition)
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
        if firstFrame == true {
            initialTime = currentTime
            firstFrame = false
        }
        timerTime = currentTime - initialTime
    }
    
    //MARK: Players
    //Setup mainPlayer
    func setupMainPlayer() {
        addPlayer(spriteNode: mainPlayerNode, size: mainPlayerSize, position: CGPoint(x: -50, y: 150))
        mainPlayerNode.zPosition = 10
        CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .run)
        isIdle = false
    }
    
    //Move mainPlayer
    func moveMainPlayer() {
//        if !isIdle {
        CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .run)
            //isIdle = false
//        }
        //cam.position.x += playerMovement
        
//        let moveRight = SKAction.moveBy(x: playerMovement, y: 0, duration: 0)
//        mainPlayerNode.run(moveRight)
        
    }
    
    //Add a player to scene
    func addPlayer(spriteNode: SKSpriteNode, size: CGSize, position: CGPoint) {
        spriteNode.size = size
        spriteNode.position = position
        
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
        //        let groundWidth: CGFloat = self.frame.size.width * 50
        let groundWidth: CGFloat = self.frame.size.width /*playerMovement * CGFloat(textArray.count) + self.frame.size.width*/
        let groundHeight: CGFloat = 100.0
        
        ground = SKSpriteNode()
        ground.texture = SKTexture(imageNamed: "ground")
        ground.anchorPoint = CGPoint.zero
        ground.position = CGPoint.zero
        ground.size = CGSize(width: groundWidth, height: groundHeight)
        addChild(ground)
    }
    
    //Sky
    func setupSky() {
        
        let skyPosition = CGPoint(x: 0.0, y: skyYPos)
        
        makeSkyAtPos(pos: skyPosition)
    }
    
    //make new sky
    func makeSkyAtPos(pos: CGPoint) {
        skyWidth = self.frame.size.width * 2
        let skyHeight: CGFloat = 200.0
        
        sky = SKSpriteNode()
        sky.texture = SKTexture(imageNamed: "sky")
        sky.anchorPoint = CGPoint.zero
        sky.position = pos
        sky.size = CGSize(width: skyWidth, height: skyHeight)
        addChild(sky)
    }
    
    //spawn sky
    var framesOfSky: CGFloat = 1.0
    
    
}

//
//  GameScene.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    //Scene
    var sceneHeight: CGFloat!
    var sceneWidth: CGFloat!
    
    //GameSession
    var gameSession: GameSession!

    //MainPlayer
    var mainPlayer: PlayerSession!
    var mainPlayerNode: SKSpriteNode!
    let mainPlayerSize = CGSize(width: 120, height: 150)
    let mainPlayerPosition = CGPoint(x: 100, y: 150)
    let playerMovement: CGFloat = 20.0
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
    let spaceBetweenLetters: CGFloat = 30
    var textNodeWidth: CGFloat!
    let inGameTextFontName = "Wraith-Arc-Blocks"
    let textFontSize: CGFloat = 50

    //Camera
    var cam: SKCameraNode!
    
    //Timer
    var timerTextNode: SKLabelNode!
    var initialTime: TimeInterval!
    var timerTime: TimeInterval!
    var firstFrame = true
    var stopTimer = false
    
    //MARK: Scene DidMove
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint.zero
        sceneHeight = self.frame.size.height
        sceneWidth = self.frame.size.width
        setupCamera()
        setupText()
        setupTextPosIndicator()
        setupBackground()
        setupMainPlayer()
        detectKeystroke()
        setupTimer()
    }
    
    //MARK: Init
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(size: CGSize, gameSesh: GameSession) {
        self.init(size: size)
        gameSession = gameSesh
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if firstFrame == true {
            initialTime = currentTime
            firstFrame = false
        }
        
        if stopTimer == false {
            timerTime = currentTime - initialTime
            updateTimer(time: timerTime)
        }
        
        neverEndingSky(widthOfSky: skyWidth)
    }
    
    //MARK: Players
    //Setup mainPlayer
    func setupMainPlayer() {
        mainPlayer = gameSession.players[0]
        mainPlayerNode = SKSpriteNode()
        addPlayer(spriteNode: mainPlayerNode, size: mainPlayerSize, position: mainPlayerPosition)
        mainPlayerNode.zPosition = 10
        CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .idle)
        isIdle = true
    }
    
    //Move mainPlayer
    func moveMainPlayer() {
        if isIdle {
            CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .run)
            isIdle = false
        }
        cam.position.x += playerMovement
        
        let moveRight = SKAction.moveBy(x: playerMovement, y: 0, duration: 0)
        mainPlayerNode.run(moveRight)
        
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
        let groundWidth: CGFloat = playerMovement * CGFloat(textArray.count) + self.frame.size.width
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
    
    //Make new sky
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
    
    //Spawn sky
    var framesOfSky: CGFloat = 1.0

    func neverEndingSky(widthOfSky: CGFloat) {
        let skyXPos = widthOfSky * framesOfSky
        let newSkyOrigin = widthOfSky * 0.75 * framesOfSky
        
        if cam.position.x >= newSkyOrigin {
            makeSkyAtPos(pos: CGPoint(x: skyXPos, y: skyYPos))
            framesOfSky += 1.0
        }
    }
    
    //MARK: Text
    //Setup
    func setupText() {
        //textContainer
        textContainerNode = SKSpriteNode()
        textContainerNode.color = UIColor.clear
        textContainerNode.anchorPoint = CGPoint.zero
        
        let textContainerXPos = -100
        let textContainerYPos = 80
        
        textContainerNode.position = CGPoint(x: textContainerXPos, y: textContainerYPos)
        textContainerNode.zPosition = 10
        cam.addChild(textContainerNode)

        //parse gameText into textArray
        textArray = NetworkManager.parseWords(words: gameSession.gameText)
        //make a labelNode for each letter in textArray
        var space: CGFloat = 0
        
        for char in textArray {
            textNode = SKLabelNode(fontNamed: inGameTextFontName)
            textNode.text = char
            textNode.horizontalAlignmentMode = .right
            textNode.fontSize = textFontSize
            textNode.fontColor = UIColor.gameRed
            textNode.position = CGPoint(x: textNode.frame.width + space, y: 0)
            textNode.zPosition = 10
            textContainerNode.addChild(textNode)
            space += spaceBetweenLetters
        }
        textContainerNode.size = CGSize(width: CGFloat(textArray.count) * spaceBetweenLetters, height: textNode.frame.height)
    }

    //Set initial properties of textPosIndicator
    func setupTextPosIndicator() {
        let textPosIndicator = SKSpriteNode()
        textPosIndicator.texture = SKTexture(imageNamed: "redSliderUp")
        textPosIndicator.size = CGSize(width: 30, height: 30)
        textPosIndicator.anchorPoint = CGPoint.zero
        
        let textPosIndicatorX = textContainerNode.position.x
        let textPosIndicatorY = textContainerNode.position.y - textPosIndicator.frame.size.height
        textPosIndicator.position = CGPoint(x: textPosIndicatorX, y: textPosIndicatorY)
        cam.addChild(textPosIndicator)
    }
    
    //Moving Text
    func moveText() {
        let movement = spaceBetweenLetters

        let moveLeft = SKAction.moveBy(x: -(movement), y: 0, duration: 0)
        textContainerNode.run(moveLeft)
    }
    
    //Detect user entered text
    func detectKeystroke() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserText(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    //Check user entered text with game text
    func checkUserText(sender: Notification) {
        let textField = sender.object as! UITextField
        let lowerText = textField.text?.lowercased()
        textField.text = ""
        
        if arrayIndex < textArray.count {
            if lowerText == textArray[arrayIndex] {
                moveText()
                moveMainPlayer()
                changeCurrentTextColor(index: arrayIndex)
                arrayIndex += 1
            }
            if arrayIndex == textArray.count {
                stopTimer = true
            }
        }
    }
    
    //Change current letter and typed letters' color
    func changeCurrentTextColor(index: Int) {
        let currentText = textContainerNode.children[index] as! SKLabelNode
        currentText.fontColor = UIColor.blue
    }
    
    //MARK: Camera
    //Setup
    func setupCamera() {
        
        cam = SKCameraNode()
        
        cam.position = CGPoint(x: self.anchorPoint.x + sceneWidth/2, y: self.anchorPoint.y + sceneHeight/2)
        cam.zPosition = 40
        self.camera = cam
        addChild(cam)
    }
    
    //MARK: Timer
    //Setup
    func setupTimer() {
        timerTextNode = SKLabelNode(fontNamed: inGameTextFontName)
        timerTextNode.fontSize = 40
        timerTextNode.horizontalAlignmentMode = .center
        timerTextNode.verticalAlignmentMode = .bottom
        timerTextNode.fontColor = .black
        timerTextNode.text = "0:00.00"
        
        let timerXPos: CGFloat = 0
        let timerYPos = sceneHeight/2 - timerTextNode.frame.size.height - 15
        
        timerTextNode.position = CGPoint(x: timerXPos, y: timerYPos)
        cam.addChild(timerTextNode)
    }
    
    //update time
    func updateTimer(time: Double) {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let miliseconds = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        timerTextNode.text = String(format:"%01i:%02i:%02i", minutes, seconds, miliseconds)
    }
}

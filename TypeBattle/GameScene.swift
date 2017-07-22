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
    let spaceBetweenLetters: CGFloat = 25
    var textNodeWidth: CGFloat!
    let inGameTextFontName = "Origami Mommy"
    let textFontSize: CGFloat = 40

    //Camera
    var cam: SKCameraNode!
    
    //Timer
    var timerTextNode: SKLabelNode!
    var initialTime: TimeInterval!
    var timerTime: TimeInterval!
    var firstFrame = true
    
    //MARK: Scene DidMove
    override func didMove(to view: SKView) {

        self.anchorPoint = CGPoint.zero
        sceneHeight = self.frame.size.height
        sceneWidth = self.frame.size.width
        setupCamera()
        setupText()
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
        updateTimer(time: timerTime)
        
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
        textContainerNode.color = UIColor.gameTeal
        textContainerNode.anchorPoint = CGPoint.zero
        textContainerNode.position = CGPoint(x: 0 - cam.position.x + 100, y: 0 + cam.position.y - 150)
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
        
        self.camera = cam
        addChild(cam)
    }
    
    //MARK: Timer
    //Setup
    func setupTimer() {
        timerTextNode = SKLabelNode(fontNamed: inGameTextFontName)
        timerTextNode.fontSize = textFontSize
        timerTextNode.fontColor = UIColor.black
        timerTextNode.text = "0.00"
        
        let timerXPos = cam.position.x + cam.frame.size.width/2 - timerTextNode.frame.size.width
        let timerYPos = cam.position.y + cam.frame.size.height/2 - timerTextNode.frame.size.height

        timerTextNode.position = CGPoint(x: timerXPos, y: timerYPos)
        cam.addChild(timerTextNode)
    }
    
    //update time
    func updateTimer(time: Double) {
        timerTextNode.text = String(format: "%.2f", time)
    }
}

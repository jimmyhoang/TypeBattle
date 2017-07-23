//
//  MultiplayerGameScene.swift
//  TypeBattle
//
//  Created by Harry Li on 2017-07-18.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import SpriteKit

protocol MultiplayerSceneDelegate: class {
    func gameDidEnd(gameSessionID: String)
}

class MultiplayerGameScene: SKScene {
    
    //Delegate
    weak var mpDelegate: MultiplayerSceneDelegate?
    
    //Scene
    var sceneHeight: CGFloat!
    var sceneWidth: CGFloat!
    
    //GameSession
    var gameSession: GameSession!
    var numberOfPlayers: Int!
    var gameTextLength: Int!
    
    //GameManager
    var gameManager: GameManager!
    
    //Dictionary
    var gameDict = Dictionary<String, Any>()
    var playerDict = Dictionary<String, Any>()

    //Current Player
    var currentPlayer: Player!
    var mainPlayerInDict: Dictionary<String, Any>!
    var mainPlayerNode: SKSpriteNode!
    var mainPlayer: PlayerSession!
    
    //Players
    var playerNode: SKSpriteNode!
    var playerNodesInGame: [SKSpriteNode] = []
    var playerProgress: Double = 0.0
    let playerSize = CGSize(width: 100, height: 120)
    let playerMovement: CGFloat = 20.0
    
    var playerNameLabelNode: SKLabelNode!
    var otherPlayerProgress: Double = 0.0
    
    //Background
    var ground: SKSpriteNode!
    var groundContainer: SKSpriteNode!
    var groundContainerHeight: CGFloat!
    
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
    
    let inGameFontName = "Origami Mommy"
    
    //Camera
    var cam: SKCameraNode!
    
    //Position Label
    var positionLabelNode: SKLabelNode!
    var myPosition = 1
    
    //Timer
    var timerTextNode: SKLabelNode!
    var initialTime: TimeInterval!
    var timerTime: TimeInterval!
    var firstFrame = true
    var stopTimer = false
    
    //countdownTimer Pos, NOT timer Pos
    var timerXPos: CGFloat!
    var timerYPos: CGFloat!
    
    
    
    //Countdown
    var countdownNode: SKLabelNode!
    var countdownTime = 10
    
    //End Game
    var isGameOver = false
    var gameEnding = false
    
    //MARK: Scene DidMove
    override func didMove(to view: SKView) {
        
        gameManager = GameManager()
        self.anchorPoint = CGPoint.zero

        sceneHeight = self.frame.size.height
        sceneWidth = self.frame.size.width
        
        setupCamera()
        setupPlayers()
        setupText()
        setupBackground()
        detectKeystroke()
        setupTimer()
        setupPositionLabel()
        observePlayerPosition()
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
    
    //MARK: Touch Events
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
        
        if stopTimer == false {
            timerTime = currentTime - initialTime
            updateTimer(time: timerTime)
        }
        
        neverEndingSky(widthOfSky: skyWidth)
    }
    
    //MARK: Players
    //Setup players
    func setupPlayers() {
        setMainUser()
        //first player position
        var playerXPos: CGFloat = 10.0
        var playerYPos: CGFloat = 17.5
        var playerZPos: CGFloat = 20.0
        numberOfPlayers = gameSession.players.count
        
        //create playerNodes
        for index in 0..<numberOfPlayers {
            playerNode = SKSpriteNode()
            playerNode.anchorPoint = CGPoint.zero
            playerNode.size = playerSize
            playerNode.position = CGPoint(x: playerXPos, y: playerYPos)
            playerNode.zPosition = playerZPos
            playerXPos += 10.0
            playerYPos += 30.0
            playerZPos -= 1.0
            
            addChild(playerNode)
            CharacterAnimation.doAction(player: playerNode, char: gameSession.players[index].gameCharacter, action: .idle)
            playerNodesInGame.append(playerNode)
            
            //create playerDict containing player-specific information
            gameDict = ["player": gameSession.players[index], "playerNode": playerNode, "endTime": 0.0]
            let key = gameSession.players[index].playerID
            playerDict.updateValue(gameDict, forKey: key)
            
            //Add namePlate for each player
            playerNameLabelNode = SKLabelNode(fontNamed: inGameFontName)
            playerNameLabelNode.horizontalAlignmentMode = .left
            playerNameLabelNode.position = CGPoint(x: playerSize.width , y: 0)
            playerNameLabelNode.fontSize = 15
            playerNameLabelNode.name = "namePlate"
            playerNameLabelNode.text = "\(gameSession.players[index].playerName) >>> \(playerProgress)%"
            playerNode.addChild(playerNameLabelNode)
            
        }
        
        mainPlayerInDict = playerDict[currentPlayer.playerID] as! Dictionary<String, Any>
        mainPlayerNode = mainPlayerInDict["playerNode"] as! SKSpriteNode
        mainPlayer = mainPlayerInDict["player"] as! PlayerSession
    }
    
    //Add a player to scene
    func addPlayer(spriteNode: SKSpriteNode, size: CGSize, position: CGPoint) {
        spriteNode.size = size
        spriteNode.position = position
        
        self.addChild(spriteNode)
    }
    
    //Move mainPlayer
    func moveMainPlayer() {
        if mainPlayer.currentIndex == 0 {
            CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .run)
        } else if mainPlayer.currentIndex == textArray.count - 1 {
            CharacterAnimation.doAction(player: mainPlayerNode, char: mainPlayer.gameCharacter, action: .idle)
        }
        cam.position.x += playerMovement
        
        let moveRight = SKAction.moveBy(x: playerMovement, y: 0, duration: 0)
        mainPlayerNode.run(moveRight)
    }
    
    //Move otherPlayers
    func moveOtherPlayer(player: PlayerSession, playerNode: SKSpriteNode, diff: Int) {
        if player.currentIndex >= 0 {
            CharacterAnimation.doAction(player: playerNode, char: player.gameCharacter, action: .run)
        } else if player.currentIndex == textArray.count - 1 {
            CharacterAnimation.doAction(player: playerNode, char: player.gameCharacter, action: .idle)
        }
        
        let moveRight = SKAction.moveBy(x: playerMovement * CGFloat(diff), y: 0, duration: 0)
        playerNode.run(moveRight)
    }
    
    //Update mainPlayerProgress text
    func updateMainPlayerProgressText() {
        let textNode = mainPlayerNode.childNode(withName: "namePlate") as! SKLabelNode
        textNode.text = "\(currentPlayer.name) >>> \(playerProgress)%"
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
        //groundContainer
        let groundContainerWidth: CGFloat = playerMovement * CGFloat(textArray.count) + self.frame.size.width
        groundContainer = SKSpriteNode()
        groundContainer.anchorPoint = CGPoint.zero
        groundContainer.position = CGPoint.zero
        
        addChild(groundContainer)
        
        //dirt ground
        let groundWidth = groundContainerWidth
        let groundHeight: CGFloat = 35.0
        
        var groundLaneYPos: CGFloat = 0.0
        let groundLaneIncrement: CGFloat = 30.0
        var groundLaneZPos: CGFloat = 10.0
        
        for _ in 0..<numberOfPlayers {
            ground = SKSpriteNode()
            ground.texture = SKTexture(imageNamed: "dirtGround")
            ground.anchorPoint = CGPoint.zero
            ground.size = CGSize(width: groundWidth, height: groundHeight)
            ground.position = CGPoint(x: 0, y: groundLaneYPos)
            ground.zPosition = groundLaneZPos
            groundContainer.addChild(ground)
            
            groundLaneYPos += groundLaneIncrement
            groundLaneZPos -= 1
        }
        
        groundContainerHeight = groundHeight + groundLaneIncrement * CGFloat(numberOfPlayers - 1)
        groundContainer.size = CGSize(width: groundContainerWidth, height: groundContainerHeight)
        
    }
    
    //Sky
    func setupSky() {
        let skyPosition = CGPoint(x: 0.0, y: groundContainerHeight)
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
            makeSkyAtPos(pos: CGPoint(x: skyXPos, y: groundContainerHeight))
            framesOfSky += 1.0
        }
    }
    
    //MARK: Game Text
    //Setup
    func setupText() {
        //textContainer
        textContainerNode = SKSpriteNode()
        textContainerNode.color = UIColor.gameTeal
        textContainerNode.anchorPoint = CGPoint.zero
        
        let textContainerXPos = -100
        let textContainerYPos = 50
        
        textContainerNode.position = CGPoint(x: textContainerXPos, y: textContainerYPos)
        textContainerNode.zPosition = 10
        cam.addChild(textContainerNode)
        
        //parse gameText into textArray
        textArray = NetworkManager.parseWords(words: gameSession.gameText)
        gameTextLength = textArray.count
        //make a labelNode for each letter in textArray
        var space: CGFloat = 0
        
        for char in textArray {
            textNode = SKLabelNode(fontNamed: inGameFontName)
            textNode.text = char
            textNode.horizontalAlignmentMode = .right
            textNode.fontSize = 40
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
        
        if mainPlayer.currentIndex < textArray.count {
            if lowerText == textArray[mainPlayer.currentIndex] {
                moveText()
                moveMainPlayer()
                changeCurrentTextColor(index: mainPlayer.currentIndex)
                mainPlayer.currentIndex += 1
                playerProgress = round(Double(mainPlayer.currentIndex)/Double(textArray.count) * 100 * 100) / 100
                gameManager.incrementPosition(gameSessionID: gameSession.gameSessionID, player: currentPlayer, index: mainPlayer.currentIndex, progress: playerProgress)
                updateMainPlayerProgressText()
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
    
    //MARK: On Camera Nodes
    //Setup timer
    func setupTimer() {
        timerTextNode = SKLabelNode(fontNamed: inGameFontName)
        timerTextNode.fontSize = 30
        timerTextNode.horizontalAlignmentMode = .center
        timerTextNode.verticalAlignmentMode = .bottom
        timerTextNode.fontColor = .black
        timerTextNode.text = "0:00.00"
        
        timerXPos = 0
        timerYPos = sceneHeight/2 - timerTextNode.frame.size.height
        
        timerTextNode.position = CGPoint(x: timerXPos, y: timerYPos)
        cam.addChild(timerTextNode)
    }
    
    //update time
    func updateTimer(time: Double) {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let miliseconds = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        timerTextNode.text = String(format:"%2i:%02i:%02i", minutes, seconds, miliseconds)
    }
    
    //Setup position label
    func setupPositionLabel() {
        positionLabelNode = SKLabelNode(fontNamed: inGameFontName)
        positionLabelNode.horizontalAlignmentMode = .left
        positionLabelNode.verticalAlignmentMode = .bottom
        positionLabelNode.fontSize = 40
        positionLabelNode.text = "1st"
        
        let positionLabelXPos = sceneWidth/2 - positionLabelNode.frame.size.width
        let positionLabelYPos = sceneHeight/2 - positionLabelNode.frame.size.height
        
        positionLabelNode.position = CGPoint(x: positionLabelXPos, y: positionLabelYPos)
        cam.addChild(positionLabelNode)
    }

    //Endgame Timer
    func startEndGameCountdown() {
        setupEndCountdownNode()
        let wait = SKAction.wait(forDuration: 1.0)
        let countdownCount = countdownTime
        let count = SKAction.run {
            self.countdownNode.text = "Game Ends In \(self.countdownTime)"
            self.countdownTime -= 1
            
            if (self.countdownNode.fontColor?.isEqual(color: UIColor.gameRed))! {
                self.countdownNode.fontColor = .gameOrange
            } else {
                self.countdownNode.fontColor = .gameRed
            }
        }
        let countOnce = SKAction.sequence([count, wait])
        let countdown = SKAction.repeat(countOnce, count: countdownCount)

        countdownNode.run(countdown) { 
            self.endGame()
        }
    }
    
    //Set initial countdownNode properties
    func setupEndCountdownNode() {
        countdownNode = SKLabelNode(fontNamed: inGameFontName)
        countdownNode.fontSize = 30
        countdownNode.horizontalAlignmentMode = .center
        countdownNode.verticalAlignmentMode = .bottom
        countdownNode.text = "Game Ends In \(self.countdownTime)"
        countdownNode.fontColor = .gameRed
        countdownNode.name = "coundownTimer"
        
        let countdownTimerXPos: CGFloat = 0
        let countdownTimerYPos = timerYPos - countdownNode.frame.size.height - 50
        
        countdownNode.position = CGPoint(x: countdownTimerXPos, y: countdownTimerYPos)
        cam.addChild(countdownNode)
    }
    
    //MARK: Leaderboard Observer
    func observePlayerPosition() {
        gameManager.observeLeaderboardChanges(gameSessionID: gameSession.gameSessionID) { (playerStatus) in
            for index in 0 ..< playerStatus.count {
                //loop through every player except currentPlayer
                if self.currentPlayer.playerID != playerStatus[index][0] as! String {
                    let playerID = playerStatus[index][0] as! String
                    let playerInfo = self.playerDict[playerID] as! Dictionary<String, Any>
                    let aPlayer = playerInfo["player"] as! PlayerSession
                    let oldIndex = aPlayer.currentIndex
                    aPlayer.currentIndex = playerStatus[index][2] as! Int
                    
                    //update progress for other players
                    self.otherPlayerProgress = round(Double(aPlayer.currentIndex)/Double(self.gameTextLength) * 100 * 100) / 100
                    let aPlayerNode = playerInfo["playerNode"] as! SKSpriteNode
                    let textNode = aPlayerNode.childNode(withName: "namePlate") as! SKLabelNode
                    textNode.text = "\(aPlayer.playerName) >>> \(self.otherPlayerProgress)%"
                    
                    if oldIndex != aPlayer.currentIndex {
                        let indexDiff = aPlayer.currentIndex - oldIndex
                        self.moveOtherPlayer(player: aPlayer, playerNode: aPlayerNode, diff: indexDiff)
                    }
                    
                    //if any player's progress is 100%, start end game counter
                    if self.gameEnding == false {
                        if playerStatus[index][3] as! Double == 100 {
                            self.gameEnding = true
//                            aPlayer.totalTime = Double(self.timerTime)
//                            self.stopTimer = true
                            self.startEndGameCountdown()
                        }
                    }
//                    else {
//                        aPlayer.totalTime = Double(self.timerTime)
//                        self.stopTimer = true
//                    }
                    
                    //check and set my position
                    if self.mainPlayer.currentIndex < aPlayer.currentIndex {
                        var tempPosition = 1
                        tempPosition += 1
                        self.myPosition = tempPosition
                    } else if self.mainPlayer.currentIndex > aPlayer.currentIndex {
                        var tempPosition = playerStatus.count
                        tempPosition -= 1
                        self.myPosition = tempPosition
                    }
                //else the currentPlayer
                } else {
                    if self.gameEnding == false {
                        if playerStatus[index][3] as! Double == 100 {
                            self.gameEnding = true
                            self.mainPlayer.totalTime = Double(self.timerTime)
                            self.gameManager.playerCompletedGame(gameSessionID: self.gameSession.gameSessionID, playerID: self.currentPlayer.playerID, totalTime: self.mainPlayer.totalTime)
                            self.stopTimer = true
                            self.startEndGameCountdown()
                        }
                    }  else {
                        self.mainPlayer.totalTime = Double(self.timerTime)
                        self.gameManager.playerCompletedGame(gameSessionID: self.gameSession.gameSessionID, playerID: self.currentPlayer.playerID, totalTime: self.mainPlayer.totalTime)
                        self.stopTimer = true
                    }
                }
            }
            self.positionLabelNode.text = self.printPosition(position: self.myPosition)
        }
    }
    
    //MARK: Get Logged User
    func setMainUser() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        currentPlayer = delegate.player
    }
    
    //MARK: End Game
    func endGame() {
//        gameManager.finishGameSession(gameSession: gameSession)
//        var tempPlayerSessionArray = [PlayerSession]()
//
//        for key in playerDict.keys {
//            let tempDict = playerDict[key] as! Dictionary<String, Any>
//            let playerSession = tempDict["player"] as! PlayerSession
//            tempPlayerSessionArray.append(playerSession)
//        }
        mpDelegate?.gameDidEnd(gameSessionID: gameSession.gameSessionID)
    }
    
    //MARK: Custom Position Print
    func printPosition(position: Int) -> String {
        switch position {
        case 1:
            return "1st"
        case 2:
            return "2nd"
        case 3:
            return "3rd"
        default:
            return "\(position)th"
        }
    }
    
}

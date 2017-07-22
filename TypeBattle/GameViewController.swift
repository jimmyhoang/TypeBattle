//
//  GameViewController.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UITextFieldDelegate, MultiplayerSceneDelegate {
    
    var keyboardHeight:CGFloat!
    var frameOfKeyboard:CGRect!
    var textField:UITextField!
    
    let screenSize = UIScreen.main.bounds
    var gameViewHeight: CGFloat!
    
    var scene: SKScene!
    var gameView: SKView!
    
    var gameSession: GameSession!
    let gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addTextFieldAndScene()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Keyboard
    
    func addTextFieldAndScene() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        textField = UITextField(frame: CGRect.zero)
        
        view.addSubview(textField)
        textField.autocorrectionType = .no
        textField.becomeFirstResponder()
        textField.isSecureTextEntry = true
        view.layoutIfNeeded()
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey:UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        frameOfKeyboard = keyboardRectangle
        keyboardHeight = keyboardRectangle.height
        setupGameScene()
    }
    
    //MARK: Setup gameScene
    
    func setupGameScene() {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        gameViewHeight = screenHeight - keyboardHeight
        
        gameView = SKView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: gameViewHeight))
        
        //check to present singlePlayer or multiPlayer
        if gameSession.players.count == 1 {
            scene = GameScene(size: gameView.frame.size, gameSesh: gameSession)
        }else {
            scene = MultiplayerGameScene(size: gameView.frame.size, gameSesh: gameSession)
            let mpScene = scene as! MultiplayerGameScene
            mpScene.mpDelegate = self
        }
        scene.scaleMode = .aspectFit
        
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.presentScene(scene)
        gameView.ignoresSiblingOrder = true
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        self.view.addSubview(gameView)
        
        //constraints
        gameView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: gameViewHeight).isActive = true
    }
    
    //MARK: Delegate
    func gameDidEnd(playerSessions: [PlayerSession]) {
        let endView = EndGameView(withPlayers: playerSessions, andFrame: frameOfKeyboard)
        textField.resignFirstResponder()
        
        endView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endView)
        
        //constraints
        endView.topAnchor.constraint(equalTo: gameView.bottomAnchor).isActive = true
        endView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        endView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        endView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

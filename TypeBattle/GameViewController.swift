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
import FirebaseDatabase //DELETE

class GameViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardHeight:CGFloat!
    var textField:UITextField!
    
    let screenSize = UIScreen.main.bounds
    var gameViewHeight: CGFloat!
    
    var scene: SKScene!
    
    var gameSession: GameSession!
    let gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ref = Database.database().reference(withPath: "game_sessions")
//        let gameRef = ref.child("-KpXRbcJjYlgcF6TcQUK")
//        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
//            
//            // try to parse dictionary to a GameSession object
//            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
//                else {
//                    print("Error getting GameSession")
//                    return
//            }
//        
//            self.gameSession = gameSession
            self.addTextFieldAndScene()
//        })
    
        
//        gameManager.observeLeaderboardChanges(gameSessionID: "-KpRMhh0FpMKP-vt_VY5") { (arrayOfArrays) in
//            print("other player changed position")
//        }
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
        view.layoutIfNeeded()
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey:UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        setupGameScene()
    }
    
    //MARK: Setup gameScene
    
    func setupGameScene() {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        gameViewHeight = screenHeight - keyboardHeight
        
        let gameView = SKView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: gameViewHeight))
        
        //check to present singlePlayer or multiPlayer
        if gameSession.players.count == 1 {
            scene = GameScene(size: gameView.frame.size, gameSesh: gameSession)
        }else {
            scene = MultiplayerGameScene(size: gameView.frame.size, gameSesh: gameSession)
        }
        scene.scaleMode = .aspectFit
        
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.presentScene(scene)
        gameView.ignoresSiblingOrder = true
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        
        self.view.addSubview(gameView)
        
        //constraints
        gameView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: gameViewHeight).isActive = true
    }
}

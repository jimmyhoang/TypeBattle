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
    var quitGameview: UIView!
    var quitGameTitleLabel: UILabel!
    var quitGameStackView: UIStackView!
    var quitNoButton: UIButton!
    var quitYesButton: UIButton!
    
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
        
        // quit button
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "red_boxCross"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToMainMenu(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        // quit panel
        quitGameview = UIView()
        quitGameview.translatesAutoresizingMaskIntoConstraints = false
        quitGameview.backgroundColor = UIColor.gameTeal
        quitGameview.layer.cornerRadius = 10
        quitGameview.layer.borderColor = UIColor.gameRed.cgColor
        quitGameview.layer.borderWidth = 4
        quitGameview.isHidden = true
        self.view.addSubview(quitGameview)
        
        quitGameview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        quitGameview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20).isActive = true
        quitGameview.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        quitGameview.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        // quit title
        quitGameTitleLabel = UILabel()
        quitGameTitleLabel.text = "Quit?"
        quitGameTitleLabel.textColor = UIColor.gameRed
        quitGameTitleLabel.font = UIFont.gameFont(size: 26)
        quitGameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.quitGameview.addSubview(quitGameTitleLabel)
        
        quitGameTitleLabel.centerXAnchor.constraint(equalTo: self.quitGameview.centerXAnchor, constant: 0).isActive = true
        quitGameTitleLabel.topAnchor.constraint(equalTo: self.quitGameview.topAnchor, constant: 8).isActive = true
        quitGameTitleLabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        // buttons inside stackview
        quitGameStackView = UIStackView()
        quitGameStackView.axis = .horizontal
        quitGameStackView.translatesAutoresizingMaskIntoConstraints = false
        quitGameStackView.distribution = .fillEqually
        quitGameStackView.spacing = 8
        self.quitGameview.addSubview(quitGameStackView)
        
        quitGameStackView.leadingAnchor.constraint(equalTo: self.quitGameview.leadingAnchor, constant: 8).isActive = true
        quitGameStackView.trailingAnchor.constraint(equalTo: self.quitGameview.trailingAnchor, constant: -8).isActive = true
        quitGameStackView.bottomAnchor.constraint(equalTo: self.quitGameview.bottomAnchor, constant: -8).isActive = true
        quitGameStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        quitYesButton = UIButton()
        quitYesButton.translatesAutoresizingMaskIntoConstraints = false
        quitYesButton.setTitle("YES", for: .normal)
        quitYesButton.titleLabel?.font = UIFont.gameFont(size: 26)
        quitYesButton.contentVerticalAlignment = .fill
        quitYesButton.setTitleColor(UIColor.gameGreen, for: .normal)
        quitYesButton.addTarget(self, action:  #selector(yesButtonPressed(sender:)), for: .touchUpInside)
        quitYesButton.backgroundColor = UIColor.gameOrange
        quitYesButton.layer.cornerRadius = 4.0
        quitGameStackView.addArrangedSubview(quitYesButton)
        
        quitNoButton = UIButton()
        quitNoButton.translatesAutoresizingMaskIntoConstraints = false
        quitNoButton.setTitle("NO", for: .normal)
        quitNoButton.titleLabel?.font = UIFont.gameFont(size: 26)
        quitNoButton.setTitleColor(UIColor.gameRed, for: .normal)
        quitNoButton.contentVerticalAlignment = .fill
        quitNoButton.backgroundColor = UIColor.gameOrange
        quitNoButton.layer.cornerRadius = 4.0
        quitNoButton.addTarget(self, action:  #selector(noButtonPressed(sender:)), for: .touchUpInside)
        quitGameStackView.addArrangedSubview(quitNoButton)
    }
    
    //MARK: Delegate
    func gameDidEnd(gameSessionID: String) {
        performSegue(withIdentifier: "gameover-segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameover-segue" {
            if let nextVC = segue.destination as? GameOverViewController {
//                nextVC. = gameSession.players
            }
        }
    }
    
    //MARK: Private Methods
    func backToMainMenu(sender:UIButton!) {
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        quitGameview.isHidden = false
    }
    
    func noButtonPressed(sender:UIButton) {
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        quitGameview.isHidden = true
    }
    
    func yesButtonPressed(sender: UIButton) {
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        quitGameview.isHidden = true
        
        let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController()
        
        let window = UIApplication.shared.windows[0] as UIWindow
        
        window.set(rootViewController: vc!)
    }
}

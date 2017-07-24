//
//  LoginViewController.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FacebookCore
import SpriteKit
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var fireloginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailButton: MainMenuButton!
    
    let screenSize = UIScreen.main.bounds
    var background: BackgroundScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate    = self
        passwordTextField.delegate = self
        
        NetworkManager.fetchPlayerDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(🚶🏿💯(sender:)), name: NSNotification.Name(rawValue:"doneAnimation"), object: nil)
    }
    
    deinit {
        print("deinited")
    }
    
    func 🚶🏿💯(sender:Notification) {
        let storyboard = UIStoryboard(name: "RegisterScreen", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController()
        let window     = UIApplication.shared.windows[0] as UIWindow
        
        let transition      = CATransition()
        transition.subtype  = kCATransitionFade
        transition.duration = 0.5
        
        window.set(rootViewController: vc!, withTransition: transition)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupBackground()
        self.background.backgroundColor = UIColor.background
    }
    
    func setupBackground() {
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //gameViewHeight = screenHeight - keyboardHeight
        
        let gameView = SKView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        background = BackgroundScene(size: gameView.frame.size)
        background.scaleMode = .aspectFit
        
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.presentScene(background)
        gameView.ignoresSiblingOrder = true
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        self.view.insertSubview(gameView, belowSubview: loginView)
        
        gameView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email    = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        NetworkManager.login(email: email, password: password) { (success, error) -> (Void) in
            if success == true {
                self.performSegue(withIdentifier: "mainmenu", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startAnimation"), object: nil)
    }
    @IBAction func facebookButton(_ sender: Any) {
        NetworkManager.facebookLogin { (success, error) -> (Void) in
            if success == true {
                self.performSegue(withIdentifier: "mainmenu", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        
        if emailTextField.canResignFirstResponder {
            emailTextField.resignFirstResponder()
        }
        
        if passwordTextField.canResignFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        
    }
}


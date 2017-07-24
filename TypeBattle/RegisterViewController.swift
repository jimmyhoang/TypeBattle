//
//  RegisterViewController.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//
import UIKit
import Firebase
import SpriteKit
class RegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: MainMenuButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var defaultAvatars: NSDictionary = [
        "cat/Idle (1)"        : UIImage(named: "cat/Idle (1)")!,
        "dog/Idle (1)"        : UIImage(named: "dog/Idle (1)")!,
        "knight/Idle (1)"     : UIImage(named: "knight/Idle (1)")!,
        "ninjaBoy/Idle__000"  : UIImage(named: "ninjaBoy/Idle__000")!,
        "ninjaGirl/Idle__000" : UIImage(named: "ninjaGirl/Idle__000")!,
        "robot/Idle (1)"      : UIImage(named: "robot/Idle (1)")!,
        "zombieBoy/Idle (1)"  : UIImage(named: "zombieBoy/Idle (1)")!,
        "zombieGirl/Idle (1)" : UIImage(named: "zombieGirl/Idle (1)")!
    ]
    
    var selectedImage          = ""
    var avatarImages:[UIImage] = []
    var checkmarkImageView:UIImageView!

    let screenSize = UIScreen.main.bounds
    var background: BackgroundScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmPasswordTextField.delegate = self
        nicknameTextField.delegate        = self
        passwordTextField.delegate        = self
        emailTextField.delegate           = self
        collectionView.delegate           = self
        tapGesture.delegate               = self
        
        setupBackground()
        self.background.backgroundColor = UIColor.background
        
        avatarImages              = defaultAvatars.allValues as! [UIImage]

        cancelButton.backgroundColor = UIColor.gameRed
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.gameFont(size: 30.0)
        cancelButton.layer.cornerRadius = 4.0
        
        registerButton.backgroundColor = UIColor.gameRed
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.gameFont(size: 30.0)
        registerButton.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
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
        
        self.view.insertSubview(gameView, belowSubview: cancelButton)
        
        gameView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func screenTapped(_ sender: Any) {
        
        if emailTextField.canResignFirstResponder {
            emailTextField.resignFirstResponder()
        }
        
        if passwordTextField.canResignFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        
        if nicknameTextField.canResignFirstResponder {
            nicknameTextField.resignFirstResponder()
        }
        
        if confirmPasswordTextField.canResignFirstResponder {
            confirmPasswordTextField.resignFirstResponder()
        }
        
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        guard let password = passwordTextField.text, let confirm = confirmPasswordTextField.text, let nickname = nicknameTextField.text, let email = emailTextField.text else {return}
        
        if password.characters.count < 6 {
            let alertController = UIAlertController(title: "Error", message: "Password must be min 6 characters", preferredStyle: .alert)
            let defaultAction   = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if confirmPassword(password: password, confirm: confirm) {
            NetworkManager.registerUser(email: email, password: password, nickname: nickname, avatarName: selectedImage, completion: { () -> (Void) in
                self.performSegue(withIdentifier: "mainmenu", sender: self)
            })
        } else {
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match!", preferredStyle: .alert)
            
            let defaultAction   = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController()
        let window     = UIApplication.shared.windows[0] as UIWindow
        
        let transition      = CATransition()
        transition.subtype  = kCATransitionFade
        transition.duration = 0.5
        
        window.set(rootViewController: vc!, withTransition: transition)
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell               = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarPickerCollectionViewCell
        cell.avatarImage.image = avatarImages[indexPath.item]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell        = collectionView.cellForItem(at: indexPath) as! AvatarPickerCollectionViewCell
        let image       = cell.avatarImage.image
        cell.isSelected = true

        blueCheckmark(cell: cell)

        for (key,value) in defaultAvatars {
            if value as? UIImage == image {
                selectedImage = key as! String
            }
        }
    }
    

    
    // MARK: - TextfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Helpers
    func confirmPassword(password:String,confirm:String) -> Bool {
        if password == confirm {
            return true
        } else {
            return false
        }
    }
    
    func blueCheckmark(cell: UICollectionViewCell) {
        if checkmarkImageView == nil {
            checkmarkImageView = UIImageView(image: UIImage(named: "blue_checkmark"))
            cell.addSubview(checkmarkImageView)
            
            checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            checkmarkImageView.contentMode                               = .scaleAspectFill
            checkmarkImageView.frame                                     = CGRect(x: 0, y: 0, width: 50, height: 50)
            checkmarkImageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            checkmarkImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        }
    }
    
    // MARK: - GestureDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        
        if view?.tag != 100 {
            return false
        }
        
        return true
    }
    
    func createMenuButton(title:String!) -> MainMenuButton {
        let button = MainMenuButton()
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gameRed
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.gameFont(size: 30.0)
        button.layer.cornerRadius = 4.0
        return button
    }
}

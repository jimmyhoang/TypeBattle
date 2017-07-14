//
//  RegisterViewController.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//
import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "players")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - Actions
    @IBAction func registerButton(_ sender: UIButton) {
        
        guard let password = passwordTextField.text, let confirm = confirmPasswordTextField.text, let nickname = nicknameTextField.text, let email = emailTextField.text else {return}
        
        if confirmPassword(password: password, confirm: confirm) {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error == nil {
                            guard let user = user else {
                                return
                            }
                            let newPlayer = Player(name: nickname, playerID: user.uid)
                            let playerRef = self.ref.child(nickname.lowercased())
                            
                            playerRef.setValue(newPlayer.toAnyObject())
                            
                            self.performSegue(withIdentifier: "mainmenu", sender: self)
                        }
                    })
                }
            })
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func confirmPassword(password:String,confirm:String) -> Bool {
        if password == confirm {
            return true
        } else {
            return false
        }
    }

}

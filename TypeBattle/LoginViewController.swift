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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var fireloginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate    = self
        passwordTextField.delegate = self
        
        NetworkManager.fetchPlayerDetails()
        
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
        performSegue(withIdentifier: "registerscreen", sender: self)
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


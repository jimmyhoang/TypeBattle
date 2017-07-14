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

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    //MARK: Properties
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var fireloginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (AccessToken.current != nil)
        {
            performSegue(withIdentifier: "mainmenu", sender: self)
        }
        else
        {
            let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
            loginButton.delegate = self
            loginView.addSubview(loginButton)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            loginButton.topAnchor.constraint(equalTo: fireloginButton.bottomAnchor, constant: 20.0).isActive = true
            loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive                  = true
        }

    }

    // MARK: - FBLoginButtonDelegate
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("cancelled")
        case .success(_, _,_):
            let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                guard error != nil else{return}
                self.performSegue(withIdentifier: "mainmenu", sender: self)
            }
        }
        
    }
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error == nil {
                
                // TODO: Make segue
                self.performSegue(withIdentifier: "mainmenu", sender: self)
                
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func registerButton(_ sender: UIButton) {
        
        // TODO: Make segue
        performSegue(withIdentifier: "registerscreen", sender: self)
    }
    

}

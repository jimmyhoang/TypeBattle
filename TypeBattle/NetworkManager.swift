//
//  NetworkManager.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation
import Firebase
import FacebookLogin
import FacebookCore

class NetworkManager{
    
    class func registerUser(email: String, password: String, nickname: String, completion: () -> (Void)) {
        let ref = Database.database().reference(withPath: "players")
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        guard let user = user else {return}
                        
                        let newPlayer = Player(name: nickname, playerID: user.uid)
                        let playerRef = ref.child(nickname.lowercased())
                        
                        playerRef.setValue(newPlayer.toAnyObject())
                    }
                })
            }
        }
    }
    
    class func login(email: String, password: String, completion:@escaping (Bool?, String?) -> (Void)){
        var loginSuccess = false
        var errorDescription = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {loginSuccess = true}
            else {
                guard let error = error else {return}
                errorDescription = error.localizedDescription
            }
            completion(loginSuccess, errorDescription)
        }
    }
 
    class func facebookLogin(completion:@escaping (Bool?, String?) -> (Void)) {
        let loginManager = LoginManager()
        var errorDescription = ""
        var loginSuccess = false
        
        loginManager.logIn([ReadPermission.publicProfile, ReadPermission.email], viewController: nil) { (result) in
            switch result {
            case .failed(let error):
                errorDescription = error.localizedDescription
            case .cancelled:
                errorDescription = "Facebook connect cancelled!"
            case .success(_,_,_):
                let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if error == nil {
                        loginSuccess = true
                    } else {
                        guard let error = error else {return}
                        errorDescription = error.localizedDescription
                    }
                    completion(loginSuccess,errorDescription)
                })
            }
        }
    }
    
    class func fetchPlayerDetails(userUID:String) {
        
    }
    
}




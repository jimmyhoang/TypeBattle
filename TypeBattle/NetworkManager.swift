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
    
    class func registerUser(email: String, password: String, nickname: String, avatarName: String, completion: @escaping () -> (Void)) {
        let ref = Database.database().reference(withPath: "players")
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        guard let user = user else {return}
                        
                        let newPlayer = Player(name: nickname, playerID: user.uid,avatarName: avatarName)
                        let playerRef = ref.child(user.uid.lowercased())
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.player = newPlayer
                        
                        playerRef.setValue(newPlayer.toAnyObject())
                    }
                    completion()
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
//                        guard let name = UserProfile.current?.fullName else {return}
                        
                        
                        
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
    
    class func fetchPlayerDetails() {
        let ref           = Database.database().reference(withPath: "players")
        guard let userID  = Auth.auth().currentUser?.uid else {return}
        let appDelegate   = UIApplication.shared.delegate as! AppDelegate
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {return}
            
            guard let players          = snapshot.value as? NSDictionary else {return}
            guard let user             = players.object(forKey: userID) as? NSDictionary else {return}
            guard let name             = user.object(forKey: "name") as? String else {return}
            guard let avatarName       = user.object(forKey: "avatarName") as? String else {return}
            guard let level            = user.object(forKey: "level") as? Int else {return}
            guard let levelProgression = user.object(forKey: "levelProgression") as? Double else {return}
            guard let matchesPlayed    = user.object(forKey: "matchesPlayed") as? Int else {return}
            guard let matchesWon       = user.object(forKey: "matchesWon") as? Int else {return}
            
            let newPlayer = Player(name: name, playerID: "zmtbgb6fifvlpmp1hbjzg5saq7s2", avatarName: avatarName)
            newPlayer.level            = level
            newPlayer.levelProgression = levelProgression
            newPlayer.matchesPlayed    = matchesPlayed
            newPlayer.matchesWon       = matchesWon
            appDelegate.player? = newPlayer
        })
    }
    
    class func downloadFBImage() {
        
    }

}




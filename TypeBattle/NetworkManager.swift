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
import Nuke

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
        let loginManager     = LoginManager()
        var errorDescription = ""
        var loginSuccess     = false
        let ref              = Database.database().reference(withPath: "players")

        
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
                        let params = ["fields": "picture, name"]
                        let graphRequest = GraphRequest(graphPath: "me", parameters: params, accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod.GET, apiVersion: GraphAPIVersion.defaultVersion)
                        
                        
                        graphRequest.start({ (urlResponse, graphResult) in
                            switch graphResult {
                            case .failed (let error):
                                print(error)
                            case .success (let graphResponse):
                                
                                guard let responseDictionary = graphResponse.dictionaryValue else {return}
                                let photoDict                = responseDictionary["picture"] as! NSDictionary
                                let dataDict                 = photoDict["data"] as! NSDictionary
                                
                                
                                
                                let name       = responseDictionary["name"] as! String
                                guard let url  = dataDict["url"] else {return}
                                
                                guard let stringURL = URL(string: url as! String) else {return}
                                
                                guard let user = user else {return}
                                let newPlayer  = Player(name: name, playerID: user.uid, avatarName: "")
                                
                                DispatchQueue.main.async {
                                    downloadFBImage(url: stringURL, completion: { (image) -> (Void) in
                                        newPlayer.avatar = image
                                    })
                                }
                                
                                let playerRef      = ref.child(user.uid.lowercased())
                                let appDelegate    = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.player = newPlayer
                                
                                playerRef.setValue(newPlayer.toAnyObject())
                                
                                loginSuccess = true
                                completion(loginSuccess,errorDescription)
                            }
                        })
                    } else {
                        guard let error  = error else {return}
                        errorDescription = error.localizedDescription
                        completion(loginSuccess,errorDescription)
                    }
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
    
    class func downloadFBImage(url:URL, completion:@escaping (UIImage) -> (Void)) {
        Cache.shared.removeAll()
        Manager.shared.loadImage(with: url, completion: { (result) in
            guard let image = result.value else {return}
            completion(image)
        })
    }

}




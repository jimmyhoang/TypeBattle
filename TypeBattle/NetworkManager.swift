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
import SwiftyJSON

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
                        
                        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.player = newPlayer
                        
                        playerRef.setValue(newPlayer.toAnyObject())
                    }
                    completion()
                })
            }
        }
    }
    
    class func login(email: String, password: String, completion:@escaping (Bool?, String?) -> (Void)){
        var loginSuccess     = false
        var errorDescription = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                fetchPlayerDetails(completion: { (success) in
                    if success {
                        loginSuccess = true
                    }
                })
            }
            else {
                guard let error  = error else {return}
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
                let credential   = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    
                    fetchPlayerDetails(completion: { (success) in
                        
                        if success {
                            loginSuccess = true
                            completion(loginSuccess, errorDescription)
                        }
                        
                        if !success {
                            let params = ["fields": "picture.type(large), name"]
                            let graphRequest = GraphRequest(graphPath: "me", parameters: params, accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod.GET, apiVersion: GraphAPIVersion.defaultVersion)
                            
                            graphRequest.start({ (urlResponse, graphResult) in
                                switch graphResult {
                                case .failed (let error):
                                    print(error)
                                case .success (let graphResponse):
                                    
                                    guard let responseDictionary = graphResponse.dictionaryValue else {return}
                                    let photoDict                = responseDictionary["picture"] as! NSDictionary
                                    let dataDict                 = photoDict["data"] as! NSDictionary
                                    
                                    let name             = responseDictionary["name"] as! String
                                    guard let url        = dataDict["url"] as? String else {return}
                                    guard let stringURL  = URL(string: url) else {return}
                                    guard let user       = user else {return}
                                    let newPlayer        = Player(name: name, playerID: user.uid, avatarName: "")
                                    newPlayer.avatarName = "facebook"
                                    newPlayer.fbPicURL   = url
                                    
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

                } )
            }
        }
    }
    
    class func fetchPlayerDetails(playerID: String, withCompletionBlock block: @escaping (Player) -> Swift.Void) {
        let ref           = Database.database().reference(withPath: "players")
        let pRef          = ref.child(playerID)
        pRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {return}
            
            guard let user             = snapshot.value as? NSDictionary else {return}
            guard let name             = user.object(forKey: "name") as? String else {return}
            guard let avatarName       = user.object(forKey: "avatarName") as? String else {return}
            guard let level            = user.object(forKey: "level") as? Int else {return}
            guard let levelProgression = user.object(forKey: "levelProgression") as? Double else {return}
            guard let matchesPlayed    = user.object(forKey: "matchesPlayed") as? Int else {return}
            guard let matchesWon       = user.object(forKey: "matchesWon") as? Int else {return}

            
            let newPlayer              = Player(name: name, playerID: playerID, avatarName: avatarName)

            if let fbPicURL         = user.object(forKey: "fbPicURL") as? String {
                newPlayer.fbPicURL         = fbPicURL
            }
            
            newPlayer.level            = level
            newPlayer.levelProgression = levelProgression
            newPlayer.matchesPlayed    = matchesPlayed
            newPlayer.matchesWon       = matchesWon

            if avatarName == "facebook" {
                downloadFBImage(url: URL(string:newPlayer.fbPicURL!)!, completion: { (image) -> (Void) in
                    newPlayer.avatar = image
                })
            }
            
            block(newPlayer)
        })

    }
    
    class func fetchPlayerDetails(completion: @escaping (Bool) -> Swift.Void) {
       
        guard let userID  = Auth.auth().currentUser?.uid.lowercased() else {return}
        let appDelegate   = UIApplication.shared.delegate as! AppDelegate
        
        self.fetchPlayerDetails(playerID: userID) { (player) in
            appDelegate.player = player
            completion(true)
        }
    }

    class func downloadFBImage(url:URL, completion:@escaping (UIImage) -> (Void)) {
        Cache.shared.removeAll()
        Manager.shared.loadImage(with: url, completion: { (result) in
            guard let image = result.value else {return}
            completion(image)
        })
    }
    
    class func loadPlayers(completion:@escaping (Player?) -> ()) {
        let ref = Database.database().reference(withPath: "players")
        
        ref.queryOrdered(byChild: "matchesWon").observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            let rawPlayers = snapshot.value as! NSDictionary
            
            for key in rawPlayers.allKeys {
                
                let rawPlayer        = rawPlayers.object(forKey: key) as! NSDictionary
                guard let name       = rawPlayer.object(forKey: "name") as? String else {continue}
                guard let id         = rawPlayer.object(forKey: "playerID") as? String else {continue}
                guard let avatarName = rawPlayer.object(forKey: "avatarName") as? String else {continue}
                guard let matchesWon = rawPlayer.object(forKey: "matchesWon") as? Int else {continue}
                guard let level      = rawPlayer.object(forKey: "level") as? Int else {continue}
                
                let player           = Player(name: name, playerID: id, avatarName: avatarName)
                player.matchesWon    = matchesWon
                player.level         = level
                
                completion(player)
            }
        })
    }

    class func getWords(category:String, completion:@escaping (String) -> ()) {
        var number            = 0
        let lowerCategory     = category.lowercased()
        
        switch lowerCategory {
        case "poem":
            number = Int(arc4random_uniform(20))
        case "quote":
            number = Int(arc4random_uniform(50))
        default:
            break
        }
        
        var components    = URLComponents()
        components.scheme = "https"
        components.host   = "typeiama.vapor.cloud"
        components.path   = "/\(lowerCategory)/\(number)"
        
        let url       = components.url
        let request   = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            guard let data = data else {
                print("data is nil")
                return
            }
            
            let json = JSON(data: data)

            if let text = json[lowerCategory].string {
                let lowerCased = text.lowercased()
                completion(lowerCased)
            }
        }
        task.resume()
    }
    
    class func parseWords(words:String) -> [String] {
        var parsedWords:[String] = []
        
        for element in words.characters {
            parsedWords.append(String(element))
        }
        
        return parsedWords
    }
}




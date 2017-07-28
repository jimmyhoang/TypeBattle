//
//  AppDelegate.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var player = Player()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

//        MusicHelper.sharedHelper.playBackgroundMusic()
       
        var storyboard:UIStoryboard
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "backgroundMusicStatus") as? String == "On" {
            MusicHelper.sharedHelper.playBackgroundMusic()
        }
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            try! Auth.auth().signOut()
            
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.set("On", forKey: "backgroundMusicStatus")
            userDefaults.synchronize() // Forces the app to update UserDefaults
            MusicHelper.sharedHelper.playBackgroundMusic()
        }
        
        if Auth.auth().currentUser?.uid == nil {
            storyboard = UIStoryboard.init(name: "Login", bundle: .main)
        } else {
            NetworkManager.fetchPlayerDetails(completion: { (success) in
            })
            storyboard = UIStoryboard.init(name: "MainMenu", bundle: .main)
        }
        
        let rootVC = storyboard.instantiateInitialViewController()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        MusicHelper.sharedHelper.stopBackgroundMusic()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // get root view controller
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        //
        
        // go to presentedviewcontroller
        while let next = top.presentedViewController {
            top = next
        }

        // check if it is the join room vc
        if let controller = top as? JoinRoomViewController {
            
            controller.userLeftLobby()
    
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEventsLogger.activate(application)
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "backgroundMusicStatus") as? String == "On" {
            MusicHelper.sharedHelper.playBackgroundMusic()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application:UIApplication,open openURLurl:URL,sourceApplication:String?,annotation:Any)->Bool {
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions:[:])
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplicationExtensionPointIdentifier.keyboard {
            return false
        }
        
        return true
    }

}


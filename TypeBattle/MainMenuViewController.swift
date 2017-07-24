//
//  MainMenuViewController.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-21.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var gameSession: GameSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.fetchPlayerDetails { (success) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTraining" {
            let destinationVC = segue.destination as! GameViewController
            destinationVC.gameSession = self.gameSession
        }

    }
    

}

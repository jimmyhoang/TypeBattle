//
//  GameOverViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-22.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var finalPositionLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var currentPlayer: Player!
    var playersSession = [PlayerSession]()
    var gameSessionID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
        
        // Set up view interface
        self.backButton.layer.cornerRadius = 4.0
        self.backButton.contentVerticalAlignment = .fill
        
        // Get GameSessionData
        if(self.gameSessionID != "") {
            let gameManager = GameManager()
            gameManager.getGameSession(gameSessionID: self.gameSessionID) { (gs) in
                
                self.playersSession = gs.players
                
                // Sort PlayerSession by time completion
                self.playersSession.sort { (p1, p2) -> Bool in
                    return p1.totalTime < p2.totalTime
                }
                
                // Move Did Not Finished players (position 0 and time 0) to the end of the array
                for p in self.playersSession {
                    if (p.totalTime == 0) {
                        let player = self.playersSession.removeFirst()
                        self.playersSession.append(player)
                    }
                    else {
                        break
                    }
                }
                
                // Set final positions
                for position in 0 ..< self.playersSession.count {
                    
                    if (self.playersSession[position].totalTime == 0) {
                        break
                    }
                    
                    self.playersSession[position].finalPosition = position + 1
                }
                
                self.tableView.reloadData()
                
                // save leaderboard (only 1st position player, to avoid saving twice)
                if(self.currentPlayer.playerID == self.playersSession[0].playerID) {
                    gameManager.saveLeaderboard(gameSession: gs)
                    print(self.currentPlayer.name)
                }
            }
        }
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playersSession.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lb-cell", for: indexPath) as! FinalLeaderboardTableViewCell
        
        let player = self.playersSession[indexPath.row]
        let minutes = Int(player.totalTime) / 60 % 60
        let seconds = Int(player.totalTime) % 60
        let miliseconds = Int(player.totalTime.truncatingRemainder(dividingBy: 1) * 100)
        
        let position = indexPath.row + 1
        
        if (player.totalTime > 0) {
            cell.positionLabel.text = "\(position)"
            cell.timeLabel.text = String(format:"%01i:%02i:%02i", minutes, seconds, miliseconds)
            
            // Identify if player is the main player
            if (self.currentPlayer.playerID == player.playerID)
            {
                self.finalPositionLabel.text = printPosition(position: position)
                self.totalTimeLabel.text = String(format:"%01i:%02i:%02i", minutes, seconds, miliseconds)
            }
        }
        else
        {
            cell.positionLabel.text = "-"
            
            cell.timeLabel.text = "DNF"
            
            // Identify if player is the main player
            if (self.currentPlayer.playerID == player.playerID)
            {
                self.finalPositionLabel.text = "-"
                self.totalTimeLabel.text = "DNF"
            }
        }
        cell.nameLabel.text = player.playerName
        
        return cell
    }
    
    func printPosition(position: Int) -> String {
        switch position {
        case 1:
            return "1st"
        case 2:
            return "2nd"
        case 3:
            return "3rd"
        default:
            return "\(position)th"
        }
    }
    
    //MARK: Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Multiplayer", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController()
        
        let window = UIApplication.shared.windows[0] as UIWindow
        
        let transition      = CATransition()
        transition.subtype  = kCATransitionFade
        transition.duration = 0.5
        
        window.set(rootViewController: vc!, withTransition: transition)
    }
}

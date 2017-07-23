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
        
        // Sort PlayerSession by position
        self.playersSession.sort { (p1, p2) -> Bool in
            return p1.finalPosition < p2.finalPosition
        }
        
        // Get GameSessionData
        if(self.gameSessionID != "") {
            let gameManager = GameManager()
            gameManager.getGameSession(gameSessionID: self.gameSessionID) { (gs) in
                
                self.playersSession = gs.players
                
                // Move Did Not Finished players (position 0 and time 0) to the end of the array
                for p in self.playersSession {
                    if (p.finalPosition == 0) {
                        let player = self.playersSession.removeFirst()
                        self.playersSession.append(player)
                    }
                    else {
                        break
                    }
                }
                
                self.tableView.reloadData()
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
        
        if (player.finalPosition > 0) {
            cell.positionLabel.text = "\(player.finalPosition)"
            cell.timeLabel.text = String(format:"%01i:%02i:%02i", minutes, seconds, miliseconds)
        }
        else
        {
            cell.positionLabel.text = "-"
            
            cell.timeLabel.text = "DNF"
        }
        
        // Identify if player is the main player
        if (self.currentPlayer.playerID == player.playerID)
        {
            self.finalPositionLabel.text = printPosition(position: player.finalPosition)
            self.totalTimeLabel.text = String(format:"%01i:%02i:%02i", minutes, seconds, miliseconds)
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
}

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: erase - just sample data
        self.loadSampleData()
        
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
    
    
    }
    
    func loadSampleData() {
        
        let p = PlayerSession(playerID: "11111", playerName: "Player 1")
        p.finalPosition = 4
        p.totalTime = 71.11
        self.playersSession.append(p)
        
        let p2 = PlayerSession(playerID: "22222", playerName: "Player 2")
        p2.finalPosition = 1
        p2.totalTime = 60.53
        self.playersSession.append(p2)
        
        let p3 = PlayerSession(playerID: "33333", playerName: "Player 3")
        p3.finalPosition = 2
        p3.totalTime = 65.12
        self.playersSession.append(p3)
        
        let p4 = PlayerSession(playerID: "44444", playerName: "Player 4")
        self.playersSession.append(p4)
        
        let p5 = PlayerSession(playerID: "5555", playerName: "Player 5")
        p5.finalPosition = 3
        p5.totalTime = 72.98
        self.playersSession.append(p5)
        
        let p6 = PlayerSession(playerID: "66666", playerName: "Player 6")
        self.playersSession.append(p6)
        
        let p7 = PlayerSession(playerID: "7777", playerName: "Player 7")
        self.playersSession.append(p7)

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
            self.finalPositionLabel.text = "\(player.finalPosition)"
            self.totalTimeLabel.text = String(format:"%01i:%02i:%02i", minutes, seconds, miliseconds)
        }
        
        cell.nameLabel.text = player.playerName
        
        
        
        return cell
    }
}

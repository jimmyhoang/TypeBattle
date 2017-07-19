//
//  SimGameViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-18.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class SimGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sessionIDLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var currentIndexLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var gameSessionID: String! //HARRY
    var currentPlayer: Player! //HARRY
    var manager = GameManager() //HARRY
    var currentIndex = 0
    var playersArray = Array<Array<Any>>() //HARRY
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
        
        self.sessionIDLabel.text = gameSessionID
        self.playerLabel.text = "Player Name: \(self.currentPlayer.name)"
        self.currentIndexLabel.text = "0"
        
        manager.observeLeaderboardChanges(gameSessionID: self.gameSessionID) { (array) in
            self.playersArray.removeAll()
            
            for a in array {
                self.playersArray.append(a)
            }
            
            self.tableView.reloadData()
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        self.manager.incrementPosition(gameSessionID: gameSessionID, player: self.currentPlayer, index: self.currentIndex, progress: 0)
        self.currentIndexLabel.text = "\(self.currentIndex)"
        self.currentIndex += 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let player = self.playersArray[indexPath.row]
        
        let name = player[1] as! String
        let index = player[2] as! Int
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Name: \(name) \nCurrent Index \(index)"
        return cell
    }
}

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
    
    var gameSession: GameSession! //HARRY
    var currentPlayer: Player! //HARRY
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
        
        self.sessionIDLabel.text = self.gameSession.gameSessionID
        self.playerLabel.text = "Player Name: \(self.currentPlayer.name)"
        self.currentIndexLabel.text = "0"
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

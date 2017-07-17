//
//  LeaderboardView.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-16.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardView: UIView, UITableViewDelegate, UITableViewDataSource {

    //MARK: - properties
    var players:[Player]! = []
    
    private lazy var backButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Back")
        
        button.addTarget(self, action: #selector(backToMainMenu(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var leaderboardLabel:GameLabel = {
        let label = GameLabel()
        
        label.font = UIFont.gameFont(size: 30.0)
        label.text = "All-Time Leaderboard"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var table:UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundView?.backgroundColor = UIColor.gameRed
        table.backgroundColor = UIColor.gameRed
        table.layer.cornerRadius = 5.0
        table.bounces = false
        return table
    }()
    
    //MARK: - UIView methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.background
        
        self.addSubview(leaderboardLabel)
        
        self.addSubview(table)
        self.table.dataSource = self
        self.table.delegate = self
        table.register(LeaderboardTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.addSubview(backButton)
        
        self.setNeedsUpdateConstraints()
        
        NetworkManager.loadPlayers { (player) in
            guard let player = player else {return}
            
            self.players.append(player)
            self.table.reloadData()
        }
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([leaderboardLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50.0),
                                     leaderboardLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     table.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
                                     table.topAnchor.constraint(equalTo: leaderboardLabel.bottomAnchor, constant: 10.0),
                                     table.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     table.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
                                     backButton.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 10.0),
                                     backButton.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        super.updateConstraints()
    }
    
    //MARK: - UITableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeaderboardTableViewCell
        cell.backgroundColor = UIColor.gameRed
        let player = players[indexPath.row]
        let rank = indexPath.row + 1
        cell.rankingLabel.text = "\(rank)."
        cell.nameLabel.text = player.name
        cell.levelLabel.text = "Level: \(player.level)"
        cell.numberOfMatchesWonLabel.text = "Matches Won: \(player.matchesWon)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.gameRed
    }
    
    func backToMainMenu(sender:UIButton!) {
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        while let next = top.presentedViewController {
            top = next
        }
        
        top.dismiss(animated: true, completion: nil)
    }
    
    func createMenuButton(title:String!) -> MainMenuButton {
        let button = MainMenuButton()
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gameRed
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.gameFont(size: 30.0)
        button.layer.cornerRadius = 4.0
        return button
    }
}

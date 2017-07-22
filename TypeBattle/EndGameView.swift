//
//  EndGameView.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class EndGameView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var homeButton: MainMenuButton!
    
    var players:[PlayerSession]?

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        
//        configureView()
//    }
    
    init(withPlayers:[PlayerSession], andFrame: CGRect) {
        super.init(frame: andFrame)
        players = withPlayers
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        homeButton.backgroundColor = UIColor.gameRed
        homeButton.setTitleColor(UIColor.white, for: .normal)
        homeButton.titleLabel?.font = UIFont.gameFont(size: 30.0)
        homeButton.layer.cornerRadius = 4.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EndGameTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EndGameTableViewCell
        
//        let playerSessions = gameSession?.players
        let player = players?[indexPath.row]//playerSessions?[indexPath.row]
        
        cell.backgroundColor = UIColor.gameRed
        cell.nameLabel.text = player?.playerName ?? "---"
        cell.rankingLabel.text = "\(indexPath.row + 1)."
        
        let time = player?.totalTime ?? 0
        
        cell.timeLabel.text = (player?.finalPosition == nil) ? "Final time: DNF" : "Final time: \(time)s"
        
        return cell
    }
    
    @IBAction func returnHome(_ sender: Any) {
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        while let next = top.presentedViewController {
            top = next
        }
        
        //guard let vc = top as? GameViewController else {return}
        //vc.performSegue(withIdentifier: "mainMenuSegue", sender: vc)
        top.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.gameRed
    }
}

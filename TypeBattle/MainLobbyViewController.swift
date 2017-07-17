//
//  MainLobbyViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class MainLobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createRoomButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var availableRooms = [GameSession]()
    var selectedRoom = 0
    var gameManager = GameManager()
    var currentPlayer: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createRoomButton.contentVerticalAlignment = .fill
        createRoomButton.layer.cornerRadius = 4.0
        backButton.contentVerticalAlignment = .fill
        backButton.layer.cornerRadius = 4.0
        
        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
        
        // Disable row selection
        tableView.allowsSelection = false
        
        // Get available rooms
        gameManager.listAvailableGameSessions { (session) in
            self.availableRooms.append(session)
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "room-cell", for: indexPath) as! RoomTableViewCell
        
        let room = self.availableRooms[indexPath.row]
        cell.roomNameLabel.text = room.name
        cell.playersInGameLabel.text = "0/\(room.capacity)"
        cell.joinButton.tag = indexPath.row
        cell.joinButton.addTarget(self, action: #selector(joinRoomPressed(sender:)), for: .touchUpInside)
        return cell
    }
    
    //MARK: Actions
    func joinRoomPressed(sender: UIButton) {
        self.selectedRoom = sender.tag
        
        self.performSegue(withIdentifier: "join-room-segue", sender: self)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier ?? "" {
        case "join-room-segue":
            let controller = segue.destination as! JoinRoomViewController
            controller.currentGameSession = self.availableRooms[self.selectedRoom]
            
            // add player to room
            gameManager.addPlayerToGame(gameSessionID: self.availableRooms[self.selectedRoom].gameSessionID, player: self.currentPlayer)
        default:
            return
        }
        
    }

}

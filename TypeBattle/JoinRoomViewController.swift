//
//  JoinRoomViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class JoinRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    //MARK: Properties
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var perkDescription: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let gameManager = GameManager()
    var characters: [GameCharacter]!
    var selectedCharacterTag: Int!
    var currentGameSession: GameSession!
    var currentPlayer: Player!

    //MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up buttons
        self.backButton.contentVerticalAlignment = .fill
        self.backButton.layer.cornerRadius = 4.0
        self.readyButton.contentVerticalAlignment = .fill
        self.readyButton.layer.cornerRadius = 4.0
        self.startButton.contentVerticalAlignment = .fill
        self.startButton.layer.cornerRadius = 4.0
        
        // Load character information
        self.characters = self.gameManager.getAllCharacters()

        // Select default character
        self.selectedCharacterTag = 1
        self.characterDescription.text = self.characters[self.selectedCharacterTag - 1].typeDescription
        self.perkDescription.text = self.characters[self.selectedCharacterTag - 1].perkDescription
        
        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
        
        // If lobby was created by the logged user, show Cancel instead of Back 
        if (self.currentPlayer.playerID == self.currentGameSession.ownerID) {
            self.backButton.setTitle("Cancel", for: .normal)
        }
        
        // Set up table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Set observer to update table when changes occurr
        let ref = Database.database().reference(withPath: "game_sessions")
        let sessionRef = ref.child(self.currentGameSession.gameSessionID)
        sessionRef.observe(.value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("Error getting GameSession")
                    return
            }
            self.currentGameSession = gameSession
            
            self.tableView.reloadData()
        })
        
    }
    
    //MARK: Actions
    @IBAction func characterTapped(_ sender: UITapGestureRecognizer) {
        
        // Unselect previous character
        guard let previousImage = self.view.viewWithTag(self.selectedCharacterTag) else {
            print("Unexpected error")
            return
        }
        previousImage.backgroundColor = UIColor.gameBlue
        
        // Select character
        self.selectedCharacterTag = sender.view?.tag
        
        guard let characterImage = sender.view as? UIImageView else {
            print("Unexpected error")
            return
        }
        characterImage.backgroundColor = UIColor.gameRed
        self.characterDescription.text = self.characters[self.selectedCharacterTag - 1].typeDescription
        self.perkDescription.text = self.characters[self.selectedCharacterTag - 1].perkDescription
    }
    
    @IBAction func readyButtonPressed(_ sender: UIButton) {
        
        self.gameManager.setPlayerReady(gameSessionID: self.currentGameSession.gameSessionID, playerID: self.currentPlayer.playerID, characterType: self.characters[self.selectedCharacterTag - 1].type)
        self.readyButton.isHidden = true
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        self.gameManager.startGameSession(gameSessionID: self.currentGameSession.gameSessionID)
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentGameSession.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "player-lobby-cell", for: indexPath) as! PlayerInLobbyTableViewCell
        
        cell.playerNameLabel.text = self.currentGameSession.players[indexPath.row].playerName
        cell.statusLabel.text = self.currentGameSession.players[indexPath.row].isReady ? "Ready" : "Not ready"
        return cell
    }
}

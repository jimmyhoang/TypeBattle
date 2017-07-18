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
    @IBOutlet weak var lobbyLabel: UILabel!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var perkDescription: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var characterStackView: UIStackView!
    @IBOutlet weak var waitingForPlayerLabel: UILabel!
    @IBOutlet weak var readyButtonConstraint: NSLayoutConstraint!
    
    let gameManager = GameManager()
    var characters: [GameCharacter]!
    var selectedCharacterTag: Int!
    var currentGameSession: GameSession!
    var currentPlayer: Player!
    var timer: Timer!

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
        
        // Check if room was created by the logged user
        if (self.currentPlayer.playerID == self.currentGameSession.ownerID) {
            
            // Change Back button to Cancel (should remove the room)
            self.backButton.setTitle("Cancel", for: .normal)
            
            // Set button position
            self.readyButtonConstraint.constant = -90
            
            // Show start only for creator
            self.startButton.isHidden = false
        }
        else {
            
            // Set button position
            self.readyButtonConstraint.constant = 0
            
            // Show start only for creator
            self.startButton.isHidden = true
        }
        
        // Create a animated "Waiting for players" label
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { (timer) in
            
            // Get current number of dots
            let ellipsis = self.waitingForPlayerLabel.text?.replacingOccurrences(of: "Waiting for players", with: "", options: String.CompareOptions.caseInsensitive, range: nil)

            var newEllipsis = ""
            for _ in 0 ... (ellipsis!.characters.count % 3) {
                newEllipsis += "."
            }
                
            self.waitingForPlayerLabel.text = "Waiting for players\(newEllipsis)"
            
        })
        
        
        // Set observer to update table when changes occurr
        let ref = Database.database().reference(withPath: "game_sessions")
        let sessionRef = ref.child(self.currentGameSession.gameSessionID)
        sessionRef.observe(.value, with: { (snapshot) in
            let sessionDictionary = snapshot.value as? [String : Any] ?? [:]
            
            // try to parse dictionary to a GameSession object
            guard let gameSession = GameSession.convertToGameSession (dictionary: sessionDictionary)
                else {
                    print("This room no longer exists.")
                    DispatchQueue.main.async(execute: {
                        let alert = UIAlertController(title: "Room deleted", message: "The player who created left the game. Please choose another room.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.GoToMainLobby()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    })
                    
                    return
            }
            self.currentGameSession = gameSession
            
            // Reload table view
            self.tableView.reloadData()
            
            // Change lobby title
            self.lobbyLabel.text = "LOBBY (\(self.currentGameSession.players.count)/\(self.currentGameSession.capacity))"
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // stop the "waiting for players" label animation
        self.timer.invalidate()
    }
    
    //MARK: Actions
    @IBAction func characterTapped(_ sender: UITapGestureRecognizer) {
        
        if(self.readyButton.currentTitle?.lowercased() == "ready") {
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
    }
    
    @IBAction func readyButtonPressed(_ sender: UIButton) {
        
        var isReady: Bool
        if(self.readyButton.currentTitle?.lowercased() == "unready") {
            
            isReady = false
            self.readyButton.setTitle("Ready", for: .normal)
        }
        else {
            
            isReady = true
            self.readyButton.setTitle("Unready", for: .normal)
        }
        
        self.gameManager.setPlayerReady(gameSessionID: self.currentGameSession.gameSessionID, playerID: self.currentPlayer.playerID, characterType: self.characters[self.selectedCharacterTag - 1].type, isReady: isReady)
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        self.gameManager.startGameSession(gameSessionID: self.currentGameSession.gameSessionID)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        if(self.currentPlayer.playerID == self.currentGameSession.ownerID) {
            self.gameManager.cancelGameSession(gameSessionID: self.currentGameSession.gameSessionID)
        }
        else {
            self.gameManager.removePlayerOfGame (gameSessionID: self.currentGameSession.gameSessionID, player: self.currentPlayer)
        }
        
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
    
    // MARK: Private Methods
    func GoToMainLobby() {
        self.performSegue(withIdentifier: "cancel-join-room-segue", sender: self)
    }
}

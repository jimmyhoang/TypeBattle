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
    var lobbytimer: Timer! // just for basic "Waiting for players..." animation
    var gameTimer: Timer! // game about to start warning
    var gameTimerCounter = 5 // counter to control start of the game when creator press enter
    
    var buttonSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "buttonSound", ofType: "mp3")!)

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
        self.startButton.alpha = 0.5
        self.startButton.isEnabled = false
        
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
        self.lobbytimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { (timer) in
            
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
                        let alert = UIAlertController(title: "Room does not exists", message: "The creator of this room left the game. Please join another room.", preferredStyle: UIAlertControllerStyle.alert)
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
            
            // Enable start button if more than 1 player is in the lobby
            if (self.currentGameSession.players.count > 1) {
                self.startButton.alpha = 1.0
                self.startButton.isEnabled = true
            } else {
                self.startButton.alpha = 0.5
                self.startButton.isEnabled = false
            }
            
            // Change lobby title
            self.lobbyLabel.text = "LOBBY (\(self.currentGameSession.players.count)/\(self.currentGameSession.capacity))"
            
            // If game was started by creator send to game scene
            if (self.currentGameSession.status == .started) {
                
                if(self.readyButton.currentTitle?.lowercased() == "ready") {
                    
                    // Unselect previous character
                    guard let previousImage = self.view.viewWithTag(self.selectedCharacterTag) else {
                        print("Unexpected error")
                        return
                    }
                    previousImage.backgroundColor = UIColor.gameBlue
                    
                    // Select character Cat
                    self.selectedCharacterTag = 1
                    guard let characterImage = self.view.viewWithTag(1) as? UIImageView else {
                        print("Unexpected error")
                        return
                    }
                    characterImage.backgroundColor = UIColor.gameRed
                    self.characterDescription.text = self.characters[self.selectedCharacterTag - 1].typeDescription
                    self.perkDescription.text = self.characters[self.selectedCharacterTag - 1].perkDescription

                }
                
                self.readyButton.setTitle("unready", for: .normal)
                self.startGameTimer()
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // stop the "waiting for players" label animation
        self.lobbytimer.invalidate()
        
        if let gt = self.gameTimer {
            gt.invalidate()
        }
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
        
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
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
        
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        self.gameManager.startGameSession(gameSessionID: self.currentGameSession.gameSessionID)
        
        if currentPlayer.playerID == self.currentGameSession.ownerID {
            let date = Date()
            gameManager.setGameStartTime(gameSessionID: self.currentGameSession.gameSessionID, intervalReference: Int(date.timeIntervalSinceReferenceDate))
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        self.userLeftLobby()
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! ==  "start-game-segue") {
            let controller = segue.destination as! GameViewController
            controller.gameSession = self.currentGameSession
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
    
    func startGameTimer() {
        self.lobbytimer.invalidate()
        
        // Create a animated "Waiting for players" label
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            
            self.waitingForPlayerLabel.textColor = (self.waitingForPlayerLabel.textColor == UIColor.yellow) ? UIColor.white : UIColor.yellow
            self.waitingForPlayerLabel.text = "Game will start in \(self.gameTimerCounter)"
            
            self.gameTimerCounter -= 1
            
            if(self.gameTimerCounter == -1) {
                self.gameTimer.invalidate()
                
                self.performSegue(withIdentifier: "start-game-segue", sender: self)
            }
            
        })
    }
    
    func userLeftLobby() {
        if(self.currentPlayer.playerID == self.currentGameSession.ownerID) {
            self.gameManager.cancelGameSession(gameSessionID: self.currentGameSession.gameSessionID)
        }
        else {
            self.gameManager.removePlayerOfGame (gameSessionID: self.currentGameSession.gameSessionID, player: self.currentPlayer)
        }
    }
}

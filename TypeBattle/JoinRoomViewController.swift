//
//  JoinRoomViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class JoinRoomViewController: UIViewController {
 
    //MARK: Properties
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var perkDescription: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let gameManager = GameManager()
    var characters: [GameCharacter]!
    var selectedCharacterTag: Int!
    var currentGameSession: GameSession!

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
        
        self.gameManager.startGameSession(gameSessionID: self.currentGameSession.gameSessionID)
        
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        self.gameManager.finishGameSession(gameSessionID: self.currentGameSession.gameSessionID)
    }
}

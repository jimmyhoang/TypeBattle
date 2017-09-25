//
//  CreateRoomViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import CoreLocation

class CreateRoomViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var maxPlayersLabel: UILabel!
    @IBOutlet weak var maxPlayersSegmentedControl: UISlider!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var getLocationLabel: UILabel!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    var currentLocation: CLLocation?
    var locationManager: CLLocationManager!
    var savedGameSession: GameSession!
    var currentPlayer: Player!
    
    var buttonSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "buttonSound", ofType: "mp3")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set label for default number of players
        let defaultMaxPlayers = 2
        maxPlayersLabel.text = "\(defaultMaxPlayers)"
        maxPlayersSegmentedControl.value = Float(defaultMaxPlayers)
        
        // Hide getting location label
        self.getLocationLabel.isHidden = true
        
        // Set textview delegates
        self.roomNameTextField.delegate = self
        
        // Set up buttons
        self.cancelButton.contentVerticalAlignment = .fill
        self.cancelButton.layer.cornerRadius = 4.0
        self.createButton.contentVerticalAlignment = .fill
        self.createButton.layer.cornerRadius = 4.0
        
        // Set up segmented control
        let font = UIFont.gameFont(size: 17)
        self.categorySegmentedControl.contentVerticalAlignment = .bottom
        self.categorySegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        
        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
    }

    // MARK: Actions
    @IBAction func createRoom(_ sender: UIButton) {
        
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        guard let roomName = roomNameTextField.text else {
            print("Error getting room name")
            return
        }
        guard let maxPlayersString = maxPlayersLabel.text else {
            print("Error getting maximum players")
            return
        }
        guard let maxPlayers = Int(maxPlayersString) else {
            print("Error converting maximum player to integer value")
            return
        }
        
        // check if room name have at least 3 characters
        if (roomName.characters.count <= 3) {
            roomNameTextField.text = ""
            roomNameTextField.placeholder = "Name required (min 3 characters)"
            return
        }
        
        let manager = GameManager()
        
        // Create lobby
        let category = self.categorySegmentedControl.selectedSegmentIndex == 0 ? "quote" : "poem"
        let lobby = manager.createGameLobby(name: roomName, keyword: category, maxCapacity: maxPlayers, location: self.currentLocation, owner: self.currentPlayer)
        
        // Create session
        NetworkManager.getWords(category: category) { (someRandomText) in
            
            DispatchQueue.main.async {
                // Create room with the creator as the first player
                self.savedGameSession = manager.createGameSession(lobby: lobby, someRandomText: someRandomText, persistInFirebase: true)
                
                self.performSegue(withIdentifier: "goto-lobby-segue", sender: self)
            }
        }
        
    }

    @IBAction func maxPlayersSegmentedControl(_ sender: UISlider) {
        // set max number of players in a label
        let selectedValue = Int(sender.value)
        maxPlayersLabel.text = "\(selectedValue)"
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        // dismiss keyboard when background is tapped
        self.view.endEditing(true)
    }
    
    @IBAction func useLocationSwitched(_ sender: UISwitch) {
        
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        if(sender.isOn) {
            
            // Set up location manager
            self.locationManager = CLLocationManager()
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.delegate = self
            locationManager.requestLocation()
            
            // disable button until location is returned, show message
            self.createButton.isEnabled = false
            self.createButton.alpha = 0.5
            self.getLocationLabel.isHidden = false
        }
        else {
            
            self.locationManager.stopUpdatingLocation()
            
            // enable buttons again
            self.createButton.isEnabled = true
            self.createButton.alpha = 1.0
            self.getLocationLabel.isHidden = true
            self.currentLocation = nil
            
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "cancel-create-room-segue":
            // Play sound
            MusicHelper.sharedHelper.playButtonSound()
        case "goto-lobby-segue":
            let controller = segue.destination as! JoinRoomViewController
            controller.currentGameSession = self.savedGameSession
        default:
            return
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "goto-lobby-segue":
            // check if room name have at least 3 characters
            if ((roomNameTextField.text?.characters.count)! <= 3) {
                return false
            }
            else {
                return true
            }
        default:
            return true
        }
    }
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // dismiss keyboard when "return" is touched
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // enable button
        self.createButton.isEnabled = true
        self.createButton.alpha = 1.0
        self.getLocationLabel.isHidden = true
        
        guard let currentLocation = locations.first else {
            print("Unable to get current location")
            return
        }
        
        // set current location
        self.currentLocation = currentLocation
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get current location")
    }
    
}

//
//  MainLobbyViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import CoreLocation

class MainLobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createRoomButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nearbySwitch: UISwitch!
    @IBOutlet weak var reloadingView: UIView!
    
    var availableRooms = [GameSession]()
    var availableRoomsByLocation = [GameSession]()
    var selectedRoom = 0
    var gameManager = GameManager()
    var currentPlayer: Player!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    var buttonSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "buttonSound", ofType: "mp3")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createRoomButton.contentVerticalAlignment = .fill
        createRoomButton.layer.cornerRadius = 4.0
        backButton.contentVerticalAlignment = .fill
        backButton.layer.cornerRadius = 4.0
        reloadingView.layer.cornerRadius = 4.0
        
        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
        
        // Disable row selection
        tableView.allowsSelection = false
        
        // Get available rooms
        gameManager.listAvailableGameSessions { (session, event) in
            
            // remove current element from array in updated and deleted events
            if (event == "updated" || event == "deleted") {
                for i in 0..<self.availableRooms.count {
                    if (self.availableRooms[i].gameSessionID == session.gameSessionID) {
                        self.availableRooms.remove(at: i)
                        break
                    }
                }
            }
            
            // add new element in array in added and updated events
            if(event == "updated" || event == "added") {
                self.availableRooms.append(session)
            }
            
            // sort array alphabetically
            self.availableRooms = self.availableRooms.sorted(by: { $0.name < $1.name })
            self.tableView.reloadData()
        }
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.nearbySwitch.isOn) {
            return self.availableRoomsByLocation.count
        }
        else {
            return self.availableRooms.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "room-cell", for: indexPath) as! RoomTableViewCell
        
        let room: GameSession!
        if (self.nearbySwitch.isOn) {
            room = self.availableRoomsByLocation[indexPath.row]
        }
        else {
            room = self.availableRooms[indexPath.row]
        }
        
        
        cell.roomNameLabel.text = room.name
        cell.playersInGameLabel.text = "\(room.players.count)/\(room.capacity)"
        
        if(room.players.count == room.capacity) {
            cell.joinButton.alpha = 0.5
            cell.joinButton.isEnabled = false
        }
        else {
            cell.joinButton.alpha = 1.0
            cell.joinButton.isEnabled = true
            cell.joinButton.tag = indexPath.row
            cell.joinButton.addTarget(self, action: #selector(joinRoomPressed(sender:)), for: .touchUpInside)
        }

        return cell
    }
    
    //MARK: Actions
    func joinRoomPressed(sender: UIButton) {
        
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        self.selectedRoom = sender.tag
        
        self.performSegue(withIdentifier: "join-room-segue", sender: self)
    }
    
    @IBAction func nearbySwitchChanged(_ sender: UISwitch) {
        
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        if(sender.isOn) {
            
            // Show loading panel
            self.reloadingView.isHidden = false
            
            // Set up location manager
            self.locationManager = CLLocationManager()
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.delegate = self
            self.locationManager.requestLocation()
        }
        else {
            self.locationManager.stopUpdatingLocation()
            self.tableView.reloadData()
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier ?? "" {
        case "create-room-segue":
            // Play sound
            MusicHelper.sharedHelper.playButtonSound()
        case "back-to-main-segue":
            // Play sound
            MusicHelper.sharedHelper.playButtonSound()
        case "join-room-segue":
            let controller = segue.destination as! JoinRoomViewController
            controller.currentGameSession = self.availableRooms[self.selectedRoom]
            
            // add player to room
            gameManager.addPlayerToGame(gameSessionID: self.availableRooms[self.selectedRoom].gameSessionID, player: self.currentPlayer)
        default:
            return
        }
        
    }

    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.first else {
            print("Unable to get current location")
            return
        }
        
        // set current location
        self.currentLocation = currentLocation
        self.locationManager.stopUpdatingLocation()
        
        // list only available rooms nearby location
        guard let lat = self.currentLocation?.coordinate.latitude, let long = self.currentLocation?.coordinate.longitude else {
            print("Error in MainLobbyVC. Not able to get location")
            return
        }
        
        for i in 0..<self.availableRooms.count {
            
            if let roomLocation = self.availableRooms[i].location {
                
                let range = 5.0
                let minLat = roomLocation.coordinate.latitude.adding(range * -1.0)
                let maxLat = roomLocation.coordinate.latitude.adding(range)
                let minLong = roomLocation.coordinate.longitude.adding(range * -1.0)
                let maxLong = roomLocation.coordinate.longitude.adding(range)
                
                if (minLat < lat && maxLat > lat && minLong < long && maxLong > long) {
                    self.availableRoomsByLocation.append(self.availableRooms[i])
                }
            }
        }
        
        self.tableView.reloadData()
        
        // hide loading panel
        self.reloadingView.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get current location")
    }
}

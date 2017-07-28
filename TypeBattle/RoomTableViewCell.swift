//
//  RoomTableViewCell.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-14.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var playersInGameLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        joinButton.contentVerticalAlignment = .fill
        joinButton.layer.cornerRadius = 4.0

    }
    
    @IBAction func joinRoomButton(_ sender: UIButton) {
    }
}

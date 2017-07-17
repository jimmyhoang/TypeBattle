//
//  PlayerInLobbyTableViewCell.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-16.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class PlayerInLobbyTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

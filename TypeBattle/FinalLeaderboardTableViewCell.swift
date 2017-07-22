//
//  FinalLeaderboardTableViewCell.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-22.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class FinalLeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

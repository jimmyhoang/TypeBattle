//
//  LeaderboardTableViewCell.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-16.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    lazy var rankingLabel:GameLabel = {
        let label = GameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.gameFont(size: 18.0)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var nameLabel:GameLabel = {
        let label = GameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.gameFont(size: 16.0)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var numberOfMatchesWonLabel:GameLabel = {
        let label = GameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.gameFont(size: 15.0)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var levelLabel:GameLabel = {
        let label = GameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.gameFont(size: 15.0)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var mainHorizontalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        sv.axis = .horizontal
        //sv.spacing = 0.0
        return sv
    }()
    
    private lazy var mainVerticalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .vertical
        sv.spacing = 3.0
        return sv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainHorizontalStack)
        self.mainHorizontalStack.addArrangedSubview(rankingLabel)
        self.mainHorizontalStack.addArrangedSubview(mainVerticalStack)
        self.mainVerticalStack.addArrangedSubview(nameLabel)
        self.mainVerticalStack.addArrangedSubview(levelLabel)
        self.mainVerticalStack.addArrangedSubview(numberOfMatchesWonLabel)
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([mainHorizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     mainHorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     mainHorizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
        
        NSLayoutConstraint.activate([rankingLabel.widthAnchor.constraint(equalTo: mainHorizontalStack.widthAnchor, multiplier: 0.1)])
        
        super.updateConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

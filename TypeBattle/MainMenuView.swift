//
//  MainMenuView.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class MainMenuView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private lazy var nameLabel:GameLabel = {
        let label = GameLabel()
        label.textColor = UIColor.black
        //label.contentMode = .scaleAspectFit
        label.font = UIFont.gameFont(size: 60.0)
        label.text = "Type\nBattle"
        label.numberOfLines = 0
        label.textAlignment = .center
        //label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    private lazy var singlePlayerButton:MainMenuButton = {
        let button = MainMenuButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gameRed
        button.setTitle("Singleplayer", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.gameFont(size: 30.0)
        button.layer.cornerRadius = 4.0
        return button
    }()
    
    private lazy var multiPlayerButton:MainMenuButton = {
        let button = MainMenuButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gameRed
        button.setTitle("Multiplayer", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.gameFont(size: 30.0)
        button.layer.cornerRadius = 4.0
        return button
    }()
    
    private lazy var settingsButton:MainMenuButton = {
        let button = MainMenuButton()
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gameRed
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.gameFont(size: 30.0)
        button.layer.cornerRadius = 4.0
        return button
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(nameLabel)
//        self.setNeedsUpdateConstraints()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(nameLabel)
        self.addSubview(stack)
        
        stack.addArrangedSubview(singlePlayerButton)
        stack.addArrangedSubview(multiPlayerButton)
        stack.addArrangedSubview(settingsButton)
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([ nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                      nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50.0),
                                      stack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25.0),
                                      stack.centerXAnchor.constraint(equalTo: centerXAnchor),
                                      stack.widthAnchor.constraint(equalTo: nameLabel.widthAnchor, constant: 50.0)])
        super.updateConstraints()
    }
}

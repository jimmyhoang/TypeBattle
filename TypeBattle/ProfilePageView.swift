//
//  ProfilePageView.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-14.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class ProfilePageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var player:Player!
    
    private lazy var profilePicture:UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "knight/Idle (1)"))
        
        //uncomment the next line to init using the actual player avatar (hasn't been implemented yet)
//        imageView = UIImageView(image: self.player.avatar)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var backButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Back")
        
        button.addTarget(self, action: #selector(backToMainMenu(sender:)), for: .touchUpInside)

        return button
    }()
    
    private lazy var editProfileButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Edit Profile")
        
        button.addTarget(self, action: #selector(backToMainMenu(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nameLabel:GameLabel = {
        let label = GameLabel()
        label.font = UIFont.gameFont(size: 25.0)
        label.text = "Test Player"
        label.text = self.player.name
        
        return label
    }()
    
    private lazy var levelLabel:GameLabel = {
        let label = GameLabel()
        label.font = UIFont.gameFont(size: 25.0)
        label.text = "Level: 1"
        label.text = "Level: \(self.player.level)"
        
        return label
    }()
    
    private lazy var matchesWonLabel:GameLabel = {
        let label = GameLabel()
        label.font = UIFont.gameFont(size: 25.0)
        label.text = "Matches Won: 0"
        label.text = "Matches Won: \(self.player.matchesWon)"
        
        return label
    }()
    
    private lazy var matchesPlayedLabel:GameLabel = {
        let label = GameLabel()
        label.font = UIFont.gameFont(size: 25.0)
        label.text = "Matches Played: 3"
        label.text = "Matches Played: \(self.player.matchesPlayed)"
        
        return label
    }()
    
    private lazy var topHorizontalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        //sv.isLayoutMarginsRelativeArrangement = true
        //sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    
    private lazy var upperVerticalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .vertical
        sv.spacing = 5
        return sv
    }()
    
    private lazy var mainVerticalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    /*private lazy var bottomHorizontalStack:UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()*/
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        player = delegate.player
        
        self.backgroundColor = UIColor.background
        
        self.addSubview(topHorizontalStack)
        self.topHorizontalStack.addArrangedSubview(profilePicture)
        self.topHorizontalStack.addArrangedSubview(upperVerticalStack)
        self.upperVerticalStack.addArrangedSubview(nameLabel)
        self.upperVerticalStack.addArrangedSubview(levelLabel)
        
        self.addSubview(mainVerticalStack)
        self.mainVerticalStack.addArrangedSubview(matchesWonLabel)
        self.mainVerticalStack.addArrangedSubview(matchesPlayedLabel)
        
        self.addSubview(backButton)
        //self.addSubview(bottomHorizontalStack)
        //self.bottomHorizontalStack.addArrangedSubview(backButton)
        //self.bottomHorizontalStack.addArrangedSubview(editProfileButton)
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([topHorizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 50.0),
                                     topHorizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     topHorizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     topHorizontalStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
                                     mainVerticalStack.topAnchor.constraint(equalTo: topHorizontalStack.bottomAnchor, constant: 10.0),
                                     mainVerticalStack.widthAnchor.constraint(equalTo: topHorizontalStack.widthAnchor),
                                     backButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     backButton.topAnchor.constraint(equalTo: mainVerticalStack.bottomAnchor, constant: 10.0)
                                     //bottomHorizontalStack.widthAnchor.constraint(equalTo: topHorizontalStack.widthAnchor),
                                     //bottomHorizontalStack.topAnchor.constraint(equalTo: mainVerticalStack.bottomAnchor, constant: 10.0)
                                     //mainVerticalStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
                                     //backButton.topAnchor.constraint(equalTo: mainVerticalStack.bottomAnchor),
                                     //backButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
        //constraints for elements in the upper horizontal stack view
        NSLayoutConstraint.activate([profilePicture.widthAnchor.constraint(equalTo: topHorizontalStack.widthAnchor, multiplier: 0.3),
                                     upperVerticalStack.widthAnchor.constraint(equalTo: topHorizontalStack.widthAnchor, multiplier: 0.65)])
        super.updateConstraints()
    }
    
    func backToMainMenu(sender:UIButton!) {
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        while let next = top.presentedViewController {
            top = next
        }
        
        top.dismiss(animated: true, completion: nil)
    }

    func createMenuButton(title:String!) -> MainMenuButton {
        let button = MainMenuButton()
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gameRed
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.gameFont(size: 30.0)
        button.layer.cornerRadius = 4.0
        return button
    }
    
}

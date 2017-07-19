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
    let leaderboardIconWidth:CGFloat = 64.0
    var gameManager = GameManager()
    var currentPlayer: Player!
    var gameSession: GameSession?
    
    private lazy var nameIcon:UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "TypeBattle3D"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    private lazy var leaderboardButton:UIButton = {
        let button = UIButton()
        let icon = #imageLiteral(resourceName: "leaderboard_icon")
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(icon, for: .normal)
        button.tintColor = UIColor.gameRed
        button.backgroundColor = UIColor.clear
        
        button.addTarget(self, action: #selector(leaderboardSegue(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var singlePlayerButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Single Player")
        button.addTarget(self, action: #selector(trainingSegue(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var multiPlayerButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Multiplayer")
        
        button.addTarget(self, action: #selector(multiplayerSegue(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var settingsButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Settings")
        return button
    }()
    
    private lazy var profileButton:MainMenuButton = {
        let button = self.createMenuButton(title: "My Profile")
        
        button.addTarget(self, action: #selector(myProfileSegue(sender:)), for: .touchUpInside)
        
        return button
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(nameLabel)
//        self.setNeedsUpdateConstraints()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(colorLiteralRed: 194.0/255.0, green: 217.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        self.addSubview(nameIcon)
        self.addSubview(leaderboardButton)
        
        self.addSubview(stack)
        
        stack.addArrangedSubview(singlePlayerButton)
        stack.addArrangedSubview(multiPlayerButton)
        stack.addArrangedSubview(profileButton)
        stack.addArrangedSubview(settingsButton)
        
        // Get logged user
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.currentPlayer = delegate.player
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([ nameIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
                                      nameIcon.topAnchor.constraint(equalTo: topAnchor, constant: 50.0),
                                      nameIcon.heightAnchor.constraint(equalTo:widthAnchor, multiplier: 0.75),
                                      nameIcon.widthAnchor.constraint(equalTo: nameIcon.heightAnchor),
                                      stack.topAnchor.constraint(equalTo: nameIcon.bottomAnchor),
                                      stack.centerXAnchor.constraint(equalTo: centerXAnchor),
                                      stack.widthAnchor.constraint(equalTo: nameIcon.widthAnchor, constant: -25.0),
                                      leaderboardButton.leadingAnchor.constraint(equalTo: nameIcon.leadingAnchor, constant: -20.0),
                                      leaderboardButton.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
                                      leaderboardButton.widthAnchor.constraint(equalToConstant: leaderboardIconWidth),
                                      leaderboardButton.heightAnchor.constraint(equalTo: leaderboardButton.widthAnchor)
                                      ])
        super.updateConstraints()
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
    
    func trainingSegue(sender:UIButton!) {
        
        // Create lobby
        let category = arc4random_uniform(2) == 1 ? "quote" : "poem"
        let lobby = gameManager.createGameLobby(name: "TRAINING", keyword: category, maxCapacity: 1, location: nil, owner: self.currentPlayer)
        
        // Create session
        NetworkManager.getWords(category: category) { (someRandomText) in
            
            DispatchQueue.main.async {
                // Create room with the creator as the first player
                self.gameSession = self.gameManager.createGameSession(lobby: lobby, someRandomText: someRandomText)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                
                guard var top = UIApplication.shared.keyWindow?.rootViewController else {
                    return
                }
                while let next = top.presentedViewController {
                    top = next
                }
                
                guard let gameVC = vc as? GameViewController else {
                    print("Not able to segue to game view controller")
                    return
                }
                
                gameVC.gameSession = self.gameSession
                
                top.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    func myProfileSegue(sender:UIButton!) {
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        while let next = top.presentedViewController {
            top = next
        }
        
        top.present(vc!, animated: true, completion: nil)
    }
    
    func multiplayerSegue(sender:UIButton!) {
        let storyboard = UIStoryboard(name: "Multiplayer", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        while let next = top.presentedViewController {
            top = next
        }
        
        top.present(vc!, animated: true, completion: nil)
    }
    
    func leaderboardSegue(sender:UIButton!) {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        while let next = top.presentedViewController {
            top = next
        }
        
        top.present(vc!, animated: true, completion: nil)
    }
}

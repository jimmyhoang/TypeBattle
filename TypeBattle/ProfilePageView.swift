//
//  ProfilePageView.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-14.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase

class ProfilePageView: UIView, BGSceneDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let screenSize = UIScreen.main.bounds
    var background: BackgroundScene!
    var player:Player!
    var buttonSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "buttonSound", ofType: "mp3")!)
    
    private lazy var profilePicture:UIImageView = {
        var imageView = UIImageView(image: self.player.avatar)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
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
        label.font = UIFont.gameFont(size: 30.0)
        label.text = self.player.name
        
        return label
    }()
    
    private lazy var levelLabel:GameLabel = {
        let label = GameLabel()
        label.font = UIFont.gameFont(size: 25.0)
        label.text = "Level \(self.player.level)"
        
        return label
    }()
    
    private lazy var matchesWonLabel:GameLabel = {
        let label = GameLabel()
        label.font = UIFont.gameFont(size: 25.0)
        label.text = "Matches Won: \(self.player.matchesWon)"
        
        return label
    }()
    
    private lazy var matchesPlayedLabel:GameLabel = {
        let label = GameLabel()
        label.font = UIFont.gameFont(size: 25.0)
        label.text = "Matches Played: \(self.player.matchesPlayed)"
        
        return label
    }()
    
    private lazy var topHorizontalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.isLayoutMarginsRelativeArrangement = true
//        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .horizontal
        sv.spacing = 0
        return sv
    }()
    
    private lazy var upperVerticalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .vertical
        sv.spacing = 3
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
    
    private lazy var signoutButton:MainMenuButton = {
        let signoutButton = self.createMenuButton(title: "Sign out")
//        signoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        signoutButton.addTarget(self, action: #selector(signout(sender:)), for: .touchUpInside)
        
        return signoutButton
    }()
    
    private lazy var bottomHorizontalStack:UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        player = delegate.player
        self.setupBackground()
        self.background.backgroundColor = UIColor.background
        
        self.addSubview(topHorizontalStack)
        self.topHorizontalStack.addArrangedSubview(profilePicture)
        self.topHorizontalStack.addArrangedSubview(upperVerticalStack)
        self.upperVerticalStack.addArrangedSubview(nameLabel)
        self.upperVerticalStack.addArrangedSubview(levelLabel)
        
        self.addSubview(mainVerticalStack)
        self.mainVerticalStack.addArrangedSubview(matchesWonLabel)
        self.mainVerticalStack.addArrangedSubview(matchesPlayedLabel)
        
//        self.addSubview(signoutButton)
        
        self.addSubview(backButton)
        self.addSubview(bottomHorizontalStack)
        self.bottomHorizontalStack.addArrangedSubview(backButton)
        self.bottomHorizontalStack.addArrangedSubview(signoutButton)
        //self.bottomHorizontalStack.addArrangedSubview(editProfileButton)
        
        background.bgDelegate = self
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([topHorizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 50.0),
                                     topHorizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
                                     topHorizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
                                     topHorizontalStack.heightAnchor.constraint(equalToConstant: 100),
                                     mainVerticalStack.topAnchor.constraint(equalTo: topHorizontalStack.bottomAnchor, constant: 10.0),
                                     mainVerticalStack.widthAnchor.constraint(equalTo: topHorizontalStack.widthAnchor),
                                     bottomHorizontalStack.topAnchor.constraint(equalTo: mainVerticalStack.bottomAnchor, constant: 10.0),
                                     bottomHorizontalStack.heightAnchor.constraint(equalToConstant: 60.0),
                                     bottomHorizontalStack.leadingAnchor.constraint(equalTo: topHorizontalStack.leadingAnchor),
                                     bottomHorizontalStack.trailingAnchor.constraint(equalTo: topHorizontalStack.trailingAnchor)
//                                     backButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//                                     backButton.topAnchor.constraint(equalTo: signoutButton.bottomAnchor, constant: 10.0),
//                                     signoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
//                                     signoutButton.topAnchor.constraint(equalTo: mainVerticalStack.bottomAnchor, constant: 10.0),
//                                     signoutButton.centerXAnchor.constraint(equalTo: centerXAnchor)
//                                     signoutButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 40.0)
            ])
        
        //constraints for elements in the upper horizontal stack view
        NSLayoutConstraint.activate([profilePicture.widthAnchor.constraint(equalToConstant: 100.0),
                                     upperVerticalStack.widthAnchor.constraint(equalTo: topHorizontalStack.widthAnchor, constant: -100.0)])
        super.updateConstraints()
    }
    
    func animationDidFinish() {
        let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController()
        let window     = UIApplication.shared.windows[0] as UIWindow
        
        let transition      = CATransition()
        transition.subtype  = kCATransitionFade
        transition.duration = 0.5
        
        window.set(rootViewController: vc!, withTransition: transition)
    
    }
    
    func backToMainMenu(sender:UIButton!) {
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startAnimation"), object: nil)
    }
    
    func signout(sender:UIButton!) {
        MusicHelper.sharedHelper.playButtonSound()
        
        let alertController = UIAlertController(title: "Confirmation", message: "Do you really want to sign out?", preferredStyle: .alert)
        let confirmAction   = UIAlertAction(title: "Confirm", style: .default) { (alert) in
            try! Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc         = storyboard.instantiateInitialViewController()
            let window     = UIApplication.shared.windows[0] as UIWindow
            
            let transition      = CATransition()
            transition.subtype  = kCATransitionFade
            transition.duration = 0.5
            
            window.set(rootViewController: vc!, withTransition: transition)
            
        }
        let cancelAction    = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)

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
    
    func setupBackground() {
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //gameViewHeight = screenHeight - keyboardHeight
        
        let gameView = SKView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        background = BackgroundScene(size: gameView.frame.size)
        background.scaleMode = .aspectFit
        
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.presentScene(background)
        gameView.ignoresSiblingOrder = true
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        
        self.insertSubview(gameView, belowSubview: topHorizontalStack)
        
        gameView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        
    }
    
}

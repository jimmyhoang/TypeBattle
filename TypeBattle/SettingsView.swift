//
//  SettingsView.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-20.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SpriteKit
class SettingsView: UIView, BGSceneDelegate {

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
    let userDefaults = UserDefaults.standard
    var buttonTag = 0
    
    private lazy var backButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Back")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToMainMenu(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var creditsButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Credits")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToCredits(sender:)), for: .touchUpInside)
        
        return button
    }()

    
    private lazy var soundSwitch:UISwitch = {
        let aSwitch = UISwitch()
        
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.isOn = true
        aSwitch.onTintColor = UIColor.gameOrange
        
        aSwitch.addTarget(self, action: #selector(switched(sender:)), for: .valueChanged)
        
        return aSwitch
    }()
    
    private lazy var buttonSoundSwitch:UISwitch = {
        let aSwitch = UISwitch()
        
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.isOn = true
        aSwitch.onTintColor = UIColor.gameOrange
        
        aSwitch.addTarget(self, action: #selector(buttonSwitched(sender:)), for: .valueChanged)
        
        return aSwitch
    }()
    
    private lazy var settingsLabel:GameLabel = {
        let label = GameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.gameFont(size: 40.0)
        label.text = "Settings"
        
        return label
    }()
    
    private lazy var soundLabel:GameLabel = {
        let label = GameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.gameFont(size: 30.0)
        label.text = "BG Music:"
        
        return label
    }()
    
    private lazy var buttonSoundLabel:GameLabel = {
        let label = GameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.gameFont(size: 30.0)
        label.text = "Button FX:"
        
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupBackground()
        self.background.backgroundColor = UIColor.background
        
        self.addSubview(creditsButton)
        
        self.addSubview(backButton)
        
        self.addSubview(settingsLabel)
        
        self.addSubview(soundLabel)
        
        self.addSubview(soundSwitch)
        let status = userDefaults.value(forKey: "backgroundMusicStatus") as? String
        if status == "Off" {
            soundSwitch.setOn(false, animated: false)
        }
        
        self.addSubview(buttonSoundLabel)
        
        self.addSubview(buttonSoundSwitch)
        let buttonStatus = userDefaults.value(forKey: "buttonSoundStatus") as? String
        if buttonStatus == "Off" {
            buttonSoundSwitch.setOn(false, animated: false)
        }
        
        background.bgDelegate = self
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([settingsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     settingsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50.0),
                                     soundLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 50.0),
                                     soundLabel.leadingAnchor.constraint(equalTo: settingsLabel.leadingAnchor),
                                     soundSwitch.centerYAnchor.constraint(equalTo: soundLabel.centerYAnchor),
                                     soundSwitch.leadingAnchor.constraint(equalTo: soundLabel.trailingAnchor, constant: 25.0),
                                     buttonSoundLabel.topAnchor.constraint(equalTo: soundLabel.bottomAnchor, constant: 50.0),
                                     buttonSoundLabel.trailingAnchor.constraint(equalTo: soundLabel.trailingAnchor),
                                     buttonSoundSwitch.topAnchor.constraint(equalTo: buttonSoundLabel.topAnchor),
                                     buttonSoundSwitch.leadingAnchor.constraint(equalTo: buttonSoundLabel.trailingAnchor, constant: 25.0),
                                     backButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     backButton.topAnchor.constraint(equalTo: creditsButton.bottomAnchor, constant: 30.0),
                                     creditsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     creditsButton.topAnchor.constraint(equalTo: buttonSoundLabel.bottomAnchor, constant: 30.0)
            ])
        
        super.updateConstraints()
    }
    
    func animationDidFinish() {
        let storyboard: UIStoryboard
        
        switch(buttonTag) {
        case 1:
            storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        case 2:
            storyboard = UIStoryboard(name: "Credits", bundle: nil)
        default:
            storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        }
        
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
        buttonTag = 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startAnimation"), object: nil)
    }
    
    func goToCredits(sender:UIButton!) {
        // Play sound
        MusicHelper.sharedHelper.playButtonSound()
        buttonTag = 2
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startAnimation"), object: nil)
    }
    
    func switched(sender:UISwitch) {
        if soundSwitch.isOn {
            
            userDefaults.set("On", forKey: "backgroundMusicStatus")
            MusicHelper.sharedHelper.playBackgroundMusic()
            
        } else {
            userDefaults.set("Off", forKey: "backgroundMusicStatus")
            MusicHelper.sharedHelper.stopBackgroundMusic()
            
        }
        
        userDefaults.synchronize()
        
    }
    
    func buttonSwitched(sender:UISwitch) {
        if buttonSoundSwitch.isOn {
            
            userDefaults.set("On", forKey: "buttonSoundStatus")
            
        } else {
            
            userDefaults.set("Off", forKey: "buttonSoundStatus")
            
        }
        
        userDefaults.synchronize()
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
        
        self.insertSubview(gameView, belowSubview: backButton)
        
        gameView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        gameView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        
    }

}

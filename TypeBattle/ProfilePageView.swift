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
    
    private lazy var profileButton:MainMenuButton = {
        let button = self.createMenuButton(title: "Back")
        
        button.addTarget(self, action: #selector(backToMainMenu(sender:)), for: .touchUpInside)

        return button
    }()
    
    private lazy var topHorizontalStack:UIStackView = {
        let sv = UIStackView()
        sv.alignment = UIStackViewAlignment.fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sv.axis = .horizontal
        sv.spacing = 15
        return sv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.background
        self.addSubview(topHorizontalStack)
        self.addSubview(profileButton)
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([topHorizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 50.0),
                                     topHorizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     topHorizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     topHorizontalStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
                                     profileButton.topAnchor.constraint(equalTo: topHorizontalStack.bottomAnchor),
                                     profileButton.centerXAnchor.constraint(equalTo: centerXAnchor)])
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

//
//  MainMenuButton.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class MainMenuButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.titleLabel?.frame
        frame?.size.height = self.bounds.size.height
        
        frame?.origin.y = self.titleEdgeInsets.top + 2.0
        
        self.titleLabel?.frame = frame!
        
    }
    
}

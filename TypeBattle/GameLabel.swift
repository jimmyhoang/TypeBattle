//
//  GameLabel.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class GameLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let addedHeight = font.pointSize * 0.3
        return CGSize(width: size.width, height: size.height + addedHeight)
    }
    
}

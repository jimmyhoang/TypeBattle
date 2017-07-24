//
//  UIFont+CustomFonts.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

extension UIFont {
    static func gameFont(size:CGFloat) -> UIFont {
        
        return UIFont(name: "Supersonic Rocketship", size: size)!
    }
    
    static func inGameFont(size:CGFloat) -> UIFont {
        return UIFont(name: "Origami Mommy", size: size)!
        //return UIFont(name: "betsy flanagan", size: size)!
        //return UIFont(name: "Wraith Arc Blocks", size: size)!
        //return UIFont(name: "Circled", size: size)!
    }
}

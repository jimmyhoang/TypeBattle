//
//  UIColor+CustomColors.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var gameRed: UIColor {
        
        return UIColor(red: 196.0/255.0, green:48.0/255.0, blue:43.0/255.0, alpha:1.0)
        
    }
    
    static var gameOrange: UIColor {
        
        return UIColor(red: 253.0/255.0, green:82.0/255.0, blue:0.0/255.0, alpha:1.0)
        
    }
    
    static var gameGreen: UIColor {
        
        return UIColor(red: 124.0/255.0, green:234.0/255.0, blue:156.0/255.0, alpha:1.0)
        
    }
    
    static var gameTeal: UIColor {
        
        return UIColor(red: 42.0/255.0, green:204.0/255.0, blue:193.0/255.0, alpha:1.0)
        
    }
    
    static var gameBlue: UIColor {
        
        return UIColor(red: 79.0/255.0, green:255.0/255.0, blue:237.0/255.0, alpha:1.0)
        
    }
    
    static var background: UIColor {
        return UIColor(red: 194.0/255.0, green: 217.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }
    
    func isEqual(color: UIColor?) -> Bool {
        guard let color = color else { return false }
        
        var red:CGFloat   = 0
        var green:CGFloat = 0
        var blue:CGFloat  = 0
        var alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var targetRed:CGFloat   = 0
        var targetGreen:CGFloat = 0
        var targetBlue:CGFloat  = 0
        var targetAlpha:CGFloat = 0
        color.getRed(&targetRed, green: &targetGreen, blue: &targetBlue, alpha: &targetAlpha)
        
        return (Int(red*255.0) == Int(targetRed*255.0) && Int(green*255.0) == Int(targetGreen*255.0) && Int(blue*255.0) == Int(targetBlue*255.0) && alpha == targetAlpha)
    }
}

//
//  KeystrokeDetection.swift
//  TypeBattle
//
//  Created by Harry Li on 2017-07-14.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class KeystrokeDetection:NSObject, UITextFieldDelegate {
    
    let textArray = ["a", "p", "p", "l", "e", " ", "h", "i","a", "p", "p", "l", "e", " ", "h", "i","a", "p", "p", "l", "e", " ", "h", "i"]
    let notificationCenter = NotificationCenter.default
    let notification = Notification.init(name: Notification.Name("correctInput"))
    var index = 0

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == textArray[index] {
            notificationCenter.post(notification)
            index += 1
        }
        
        return true
    }
}

//
//  KeystrokeDetection.swift
//  TypeBattle
//
//  Created by Harry Li on 2017-07-14.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class KeystrokeDetection:NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case "a":
            break
        case "b":
            break
        case "c":
            break
        case "d":
            break
        default:
            break
        }
        return true
    }
}

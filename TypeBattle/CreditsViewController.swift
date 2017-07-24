//
//  CreditsViewController.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-07-23.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {


    @IBOutlet weak var creditsView: UIView!
    @IBOutlet weak var topCreditsViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 5.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.creditsView.frame = CGRect(x: 0, y: -600, width: self.creditsView.frame.width, height: self.creditsView.frame.height)
        }, completion: nil)
    }
}

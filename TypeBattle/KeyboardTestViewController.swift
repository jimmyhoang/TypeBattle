//
//  KeyboardTestViewController.swift
//  TypeBattle
//
//  Created by Alex Lee on 2017-07-12.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class KeyboardTestViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardHeight:CGFloat!
    var textField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        textField = UITextField(frame: CGRect.zero)
        
        view.addSubview(textField)
        textField.becomeFirstResponder()
        view.layoutIfNeeded()
        print("triggered first")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey:UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        let redView = UIView(frame: CGRect(x: view.frame.size.width/2, y: self.view.frame.size.height - keyboardHeight - 50, width: 50, height: 50))
        redView.backgroundColor = UIColor.red
        view.addSubview(redView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  RegisterViewController.swift
//  TypeBattle
//
//  Created by Jimmy Hoang on 2017-07-13.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//
import UIKit
import Firebase

class RegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var defaultAvatars: NSDictionary = [
        "cat/Idle (1)"        : UIImage(named: "cat/Idle (1)")!,
        "dog/Idle (1)"        : UIImage(named: "dog/Idle (1)")!,
        "knight/Idle (1)"     : UIImage(named: "knight/Idle (1)")!,
        "ninjaBoy/Idle__000"  : UIImage(named: "ninjaBoy/Idle__000")!,
        "ninjaGirl/Idle__000" : UIImage(named: "ninjaGirl/Idle__000")!,
        "robot/Idle (1)"      : UIImage(named: "robot/Idle (1)")!,
        "zombieBoy/Idle (1)"  : UIImage(named: "zombieBoy/Idle (1)")!,
        "zombieGirl/Idle (1)" : UIImage(named: "zombieGirl/Idle (1)")!
    ]
    
    var selectedImage = ""
    var avatarImages:[UIImage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImages = defaultAvatars.allValues as! [UIImage]

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func registerButton(_ sender: UIButton) {
        
        guard let password = passwordTextField.text, let confirm = confirmPasswordTextField.text, let nickname = nicknameTextField.text, let email = emailTextField.text else {return}
        
        if confirmPassword(password: password, confirm: confirm) {
            NetworkManager.registerUser(email: email, password: password, nickname: nickname, avatarName: selectedImage, completion: { () -> (Void) in
                print("aaaaa")
                self.performSegue(withIdentifier: "mainmenu", sender: self)
            })
        } else {
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarPickerCollectionViewCell
        cell.avatarImage.image = avatarImages[indexPath.item]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AvatarPickerCollectionViewCell
        
        let image = cell.avatarImage.image
        
        for (key,value) in defaultAvatars {
            if value as? UIImage == image {
                selectedImage = key as! String
            }
        }
    }
    
    // MARK: - Helpers
    func confirmPassword(password:String,confirm:String) -> Bool {
        if password == confirm {
            return true
        } else {
            return false
        }
    }
    
}

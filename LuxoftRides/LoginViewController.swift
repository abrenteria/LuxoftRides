//
//  LoginViewController.swift
//  LuxoftRides
//
//  Created by Rene Argüelles on 4/6/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import UIKit
import QuartzCore
import TTTAttributedLabel

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var notRegisteredLabel: TTTAttributedLabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialConfigurations()
    }
    
    private func initialConfigurations() {
        self.navigationController?.isNavigationBarHidden = true
        signInButton.layer.borderWidth = 1.0
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.layer.cornerRadius = 5.0
        
        let string = notRegisteredLabel.text!
        let nsString = string as NSString
        let range = nsString.range(of: string)
        let url = NSURL(string: "")!
        notRegisteredLabel.addLink(to: url as URL!, with: range)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty && User.validateEmail(email) else {
            self.showSimpleAlert(title: "Invalid Email", message: "Please make sure your email address is correct!")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty && User.validatePassword(password) else {
            self.showSimpleAlert(title: "Invalid Password", message: "Please make sure your password is correct and has at least 8 characters!")
            return
        }
        
        if LoginManager.shared.login(email: email, password: password) == false {
            self.showSimpleAlert(title: "Could not login!", message: "Please make sure you have registered and that your email and password is correct!")
        } else {
            let controller = AppDelegate.storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
    // Unwind segues
    
    @IBAction func unwindToLoginVC(segue:UIStoryboardSegue) { }

}

extension LoginViewController: TTTAttributedLabelDelegate {

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        performSegue(withIdentifier: "GoToRegistration", sender: self)
    }

}

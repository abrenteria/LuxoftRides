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
        // TODO: Bind with taxxodium's code
    }
    
    // Unwind segues
    
    @IBAction func unwindToLoginVC(segue:UIStoryboardSegue) { }

}

extension LoginViewController: TTTAttributedLabelDelegate {

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        performSegue(withIdentifier: "GoToRegistration", sender: self)
    }

}

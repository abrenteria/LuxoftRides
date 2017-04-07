//
//  RegistrationViewController.swift
//  LuxoftRides
//
//  Created by Rene Argüelles on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class RegistrationViewController: UIViewController {
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var selectImageLabel: TTTAttributedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialConfigurations()
    }
    
    private func configure(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
    }
    
    private func configure(label: TTTAttributedLabel) {
        let string = label.text!
        let nsString = string as NSString
        let range = nsString.range(of: string)
        let url = NSURL(string: "")!
        label.addLink(to: url as URL!, with: range)
        label.delegate = self
    }
    
    private func initialConfigurations() {
        configure(button: cancelButton)
        configure(button: submitButton)
        configure(label: selectImageLabel)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoBackToLogin", sender: self)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
    }

}

extension RegistrationViewController: TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("image")
    }
    
}

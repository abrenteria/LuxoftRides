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
    
    fileprivate var userImage: UIImage?
    
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
        guard let name = self.nameTextField.text, let lastname = self.lastNameTextField.text, let email = self.emailTextField.text, let password = self.passwordTextField.text, let password_confirmation = self.passwordTextField2.text, !name.isEmpty && !lastname.isEmpty && !email.isEmpty && !password.isEmpty && !password_confirmation.isEmpty else {
            self.showSimpleAlert(title: "Invalid values for fields!", message: "Make sure all fields are filled in!")
            return
        }
        
        if password != password_confirmation {
            self.showSimpleAlert(title: "Passwords don't match!", message: "Please make sure both password fields are the same.")
            return
        }
        
        if let image = self.userImage, let imageData = UIImagePNGRepresentation(image) {
            let newUser = LoginManager.shared.register(name: name, lastname: lastname, email: email, password: password)
            newUser.avatarData = imageData as NSData
            
            if LoginManager.shared.login(email: email, password: password) {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showSimpleAlert(title: "Could not login", message: "Please try again later.") {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.showSimpleAlert(title: "No Image Selected", message: "You must select an image before registering.")
        }
    }
    @IBAction func handleUpdateAvatar(_ sender: UITapGestureRecognizer) {
        self.openImagePicker()
    }
    
    fileprivate func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension RegistrationViewController: TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        self.openImagePicker()
    }
    
}

extension RegistrationViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        userImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        userImageView.image = userImage
        
    }
    
}

extension RegistrationViewController: UINavigationControllerDelegate { }








//
//  RegistrationViewController.swift
//  LuxoftRides
//
//  Created by Rene Argüelles on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoBackToLogin", sender: self)
    }

}

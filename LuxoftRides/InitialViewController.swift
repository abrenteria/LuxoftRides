//
//  InitialViewController.swift
//  LuxoftRides
//
//  Created by Jesus De Meyer on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicatorView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.handleLogin(_:)), userInfo: nil, repeats: false)
        
    }
    
    func handleLogin(_ sender: Timer) {
        if let user = User.currentUser {
            _ = LoginManager.shared.login(email: user.email!, password: user.password!)
            self.performSegue(withIdentifier: "showMain", sender: nil)
        } else {
            self.performSegue(withIdentifier: "showLogin", sender: nil)
        }
    }

    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        indicatorView.stopAnimating()
    }

}

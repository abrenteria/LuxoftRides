//
//  LoginManager.swift
//  LuxoftRides
//
//  Created by Jesus De Meyer on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import Foundation
import CoreData

class LoginManager {
    static let shared = LoginManager()
    
    var loggedInUser: User? {
        if let userId = UserDefaults.standard.value(forKey: "user") as? String {
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            let predicate = NSPredicate(format: "identifier == %@", argumentArray: [userId])
            
            fetchRequest.predicate = predicate
            
            if let users = try? fetchRequest.execute() {
                return users.last!
            }
        }
        
        return nil
    }
    
    func login(email: String, password: String) -> Bool {
        guard let currentUser = User.current else {
            return false
        }
        
        let success = currentUser.email == email && currentUser.password == password
        
        if success {
            currentUser.isLoggedIn = true
            
            UserDefaults.standard.set(currentUser.identifier ?? "", forKey: "user")
        }
        
        return success
    }
    
    func logout() {
        guard let currentUser = User.current, currentUser.isLoggedIn == true else {
            return
        }
        
        currentUser.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
    // MARK: -
    
    func register(name: String, lastname: String, email: String, password: String) {
        let identifier = UUID().uuidString
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: DataManager.shared.managedObjectContext) as! User
        
        newUser.identifier = identifier
        newUser.name = name
        newUser.lastname = lastname
        newUser.email = email
        newUser.password = password
        
        DataManager.shared.save()
    }
    
    
}

//
//  File.swift
//  LuxoftRides
//
//  Created by Jesus De Meyer on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    class var currentUser: User? {
        guard let userId = UserDefaults.standard.value(forKey: "user") as? String else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let predicate = NSPredicate(format: "identifier == %@", argumentArray: [userId])
        
        fetchRequest.predicate = predicate
        
        if let users = try? DataManager.shared.managedObjectContext.fetch(fetchRequest), users.count > 0 {
            return users.last!
        }
        
        return nil
    }
    
    class func validateEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let result = email.range(of: regex, options: .regularExpression, range: nil, locale: nil)
        
        return result != nil
    }
    
    class func validatePassword(_ password: String) -> Bool {
        if password.isEmpty {
            return false
        }
        
        if password.distance(from: password.startIndex, to: password.endIndex) < 8 {
            return false
        }
        
        return true
    }
}

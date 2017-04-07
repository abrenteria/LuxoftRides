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
    static var current: User? {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        if let users = try? fetchRequest.execute() {
            return users.last!
        }
        
        return nil
    }
    
    class func validateEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        return email.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
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

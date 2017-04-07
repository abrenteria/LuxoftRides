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
}

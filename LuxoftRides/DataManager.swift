//
//  DataManager.swift
//  LuxoftRides
//
//  Created by Jesus De Meyer on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    let managedObjectContext: NSManagedObjectContext
    //private let backgroundManagedObjectContext: NSManagedObjectContext
    
    let persistentCoordinator: NSPersistentStoreCoordinator
    
    init() {
        let url = Bundle.main.url(forResource: "LuxoftRides", withExtension: "momd")
        
        let model = NSManagedObjectModel(contentsOf: url!)!
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let storeURL = documentsURL.appendingPathComponent("LuxoftRides.sqlite")
        
        persistentCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        _ = try? persistentCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentCoordinator
        
        managedObjectContext.name = "Main Managed Object Context"
    }
    
    func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Could not perform save")
            }
        }
    }
}

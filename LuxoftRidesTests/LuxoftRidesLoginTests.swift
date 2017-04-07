//
//  LuxoftRidesLoginTests.swift
//  LuxoftRides
//
//  Created by Jesus De Meyer on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import XCTest
@testable import LuxoftRides
import CoreData

class LuxoftRidesLoginTests: XCTestCase {
    var registeredUser: User!
    
    override func setUp() {
        super.setUp()
        
        registeredUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: DataManager.shared.managedObjectContext) as! User
        
        registeredUser.name = "Test"
        registeredUser.lastname = "User"
        registeredUser.email = "test@user.com"
        registeredUser.password = "12345678"
        
        DataManager.shared.save()
    }
    
    override func tearDown() {
        DataManager.shared.managedObjectContext.delete(registeredUser)
        DataManager.shared.save()
        
        super.tearDown()
    }
    
    func testLoginWithUnknownUser() {
        let manager = LoginManager.shared
        
        let result = manager.login(email: "invalid@user.com", password: "4567798090")
        
        XCTAssert(result == false, "Login with an invalid user should fail")
    }
    
    func testLoginWithInvalidEmail() {
        let manager = LoginManager.shared
        
        let result = manager.login(email: "invalid@user", password: "4567798090")
        
        XCTAssert(result == false, "Login with an invalid email should fail")
    }
    
    func testLoginWithInvalidPassword() {
        let manager = LoginManager.shared
        
        let result = manager.login(email: "invalid@user.com", password: "1")
        
        XCTAssert(result == false, "Login with an invalid password should fail")
    }
    
    func testLoginWithValidUser() {
        let manager = LoginManager.shared
        
        let result = manager.login(email: registeredUser.email!, password: registeredUser.password!)
        
        XCTAssert(result == true, "Login with a valid user should pass")
    }
}

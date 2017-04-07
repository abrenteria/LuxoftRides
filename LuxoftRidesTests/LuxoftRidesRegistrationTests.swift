//
//  LuxoftRidesRegistrationTests.swift
//  LuxoftRides
//
//  Created by Jesus De Meyer on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import XCTest
@testable import LuxoftRides
import CoreData

class LuxoftRidesRegistrationTests: XCTestCase {
    var newUser: User?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        if let doomedUser = newUser {
        	DataManager.shared.managedObjectContext.delete(doomedUser)
        	DataManager.shared.save()
        }
        
        super.tearDown()
    }
    
    func testRegistration() {
        let manager = LoginManager.shared
        
        let userName = "John"
        let userLastName = "Doe"
        let userEmailName = "john@doe.com"
        let userPassword = "123456789"
        
        newUser = manager.register(name: userName, lastname: userLastName, email: userEmailName, password: userPassword)
        
        XCTAssertNotNil(newUser, "New user should not be nil")
    }
    
    func testEmail() {
        let validEmail = "user@host.com"
        let invalidEmail = "test"
        
        XCTAssertTrue(User.validateEmail(validEmail), "Valid email should pass")
        XCTAssertFalse(User.validateEmail(invalidEmail), "Invalid email should not pass")
    }
    
    func testPassword() {
        let validPassword = "123abcZZZ"
        let invalidPassword = "123"
        
        XCTAssertTrue(User.validatePassword(validPassword), "Valid password should pass")
        XCTAssertFalse(User.validatePassword(invalidPassword), "Invalid password should not pass")
    }
}

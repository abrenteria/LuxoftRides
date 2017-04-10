//
//  LuxoftRidesOfferRideTests.swift
//  LuxoftRides
//
//  Created by Rene Argüelles on 4/10/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import XCTest
@testable import LuxoftRides

class LuxoftRidesOfferRideTests: XCTestCase {
    
    var offerRideUnderTest: OfferRideViewController! // SUT object
    
    override func setUp() {
        super.setUp()
        
        offerRideUnderTest = OfferRideViewController()
    }
    
    override func tearDown() {
        offerRideUnderTest = nil
        super.tearDown()
    }
    
    func testOriginIsCorrect() {
        
    }
    
}

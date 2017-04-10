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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        offerRideUnderTest = storyboard.instantiateViewController(withIdentifier: "OfferRideViewControllerId") as! OfferRideViewController
        UIApplication.shared.keyWindow!.rootViewController = offerRideUnderTest
        
        // Test and Load the View at the Same Time!
        XCTAssertNotNil(offerRideUnderTest.view)
    }
    
    override func tearDown() {
        offerRideUnderTest = nil
        super.tearDown()
    }
    
    func testSourceAddressIsValid() {
        let promise = expectation(description: "Valid entry")
        
        offerRideUnderTest.drawPin(at: "Mision san antonio 6144, zapopan 45030", type: .source) { (mark) in
            if mark != nil {
                promise.fulfill()
            } else {
                XCTFail("Invalid source address")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDestinationAddressIsValid() {
        let promise = expectation(description: "Valid entry")
        
        offerRideUnderTest.drawPin(at: "av de los empresarios 135 puerta de hierro 45116", type: .destination) { (mark) in
            if mark != nil {
                promise.fulfill()
            } else {
                XCTFail("Invalid destination address")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

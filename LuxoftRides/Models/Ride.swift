//
//  Ride.swift
//  LuxoftRides
//
//  Created by Jesus De Meyer on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Ride: NSManagedObject {
    var sourceCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.sourceLatitude, self.sourceLongitude)
    }
    
    var destinationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.destinationLatitude, self.destinationLongitude)
    }
    
}

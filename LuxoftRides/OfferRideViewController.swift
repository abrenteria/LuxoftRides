//
//  OfferRideViewController.swift
//  LuxoftRides
//
//  Created by Rene Argüelles on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import UIKit
import MapKit

class OfferRideViewController: UIViewController {
    
    var originAddress: String {
        return originTextField.text!
    }
    
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let location = "av de los empresarios 135 puerta de hierro jalisco 45030"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let placemark = placemarks?.first, let location = placemark.location {
                    let mark = MKPlacemark(placemark: placemark)
                    
                    if var region = self?.mapView.region {
                        region.center = location.coordinate
                        region.span.longitudeDelta /= 8.0
                        region.span.latitudeDelta /= 8.0
                        self?.mapView.setRegion(region, animated: true)
                        self?.mapView.addAnnotation(mark)
                    }
                }
            }
        }
    }

}

extension OfferRideViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("here")
        return true
    }
    
}

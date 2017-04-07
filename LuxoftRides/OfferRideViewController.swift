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
    
    var sourceMark: MKPlacemark?
    var destinationMark: MKPlacemark?
    
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    fileprivate func drawPin(at address: String, completion: @escaping (MKPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                if let placemark = placemarks?.first, let location = placemark.location {
                    let mark = MKPlacemark(placemark: placemark)
                    
                    if var region = self?.mapView.region {
                        region.center = location.coordinate
                        region.span.longitudeDelta /= 8.0
                        region.span.latitudeDelta /= 8.0
                        self?.mapView.setRegion(region, animated: true)
                        self?.mapView.addAnnotation(mark)
                        completion(mark)
                    }
                }
            }
        }
    }
    
    fileprivate func drawRoute() {
        guard let sourcePlacemark = sourceMark, let destinationPlacemark = destinationMark else { return }
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Source"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Destination"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }

}

extension OfferRideViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        drawPin(at: textField.text!) { [weak self] mark in
            if mark != nil {
                if textField === self?.originTextField {
                    self?.sourceMark = mark!
                } else if textField === self?.destinationTextField {
                    self?.destinationMark = mark!
                    self?.drawRoute()
                }
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
}

extension OfferRideViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
}

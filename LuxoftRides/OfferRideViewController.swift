//
//  OfferRideViewController.swift
//  LuxoftRides
//
//  Created by Rene Argüelles on 4/7/17.
//  Copyright © 2017 Jesus De Meyer. All rights reserved.
//

import UIKit
import MapKit
import CoreData

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
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                guard let placemark = placemarks?.first else {
                    completion(nil)
                    return
                }
                
                guard let location = placemark.location else {
                    completion(nil)
                    return
                }
                
                var region = self.mapView.region
                let mark = MKPlacemark(placemark: placemark)
                
                region.center = location.coordinate
                region.span.longitudeDelta /= 8.0
                region.span.latitudeDelta /= 8.0
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(mark)
                
                completion(mark)
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
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }

    @IBAction func handleSubmit(_ sender: Any) {
        guard let origin = originTextField.text, !origin.isEmpty else {
            self.showSimpleAlert(title: "Origin cannot be empty!", message: "Please add an origin before adding a new ride!")
            return
        }
        
        guard let destination = destinationTextField.text, !destination.isEmpty else {
            self.showSimpleAlert(title: "Destination cannot be empty!", message: "Please add a destination before adding a new ride!")
            return
        }
        
        self.createRide(origin: origin, destination: destination)
    }
    
    fileprivate func createRide(origin: String, destination: String) {
        guard let sourceCoordinate = self.sourceMark?.coordinate, let destinationCoordinate = self.destinationMark?.coordinate else {
            self.showSimpleAlert(title: "Could not create ride", message: "Coordinated for source and/or destination could not be found.")
            return
        }
        
        let ride = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: DataManager.shared.managedObjectContext) as! Ride
        
        ride.sourceName = origin
        ride.destinationName = destination
        ride.sourceCoordinate = sourceCoordinate
        ride.destinationCoordinate = destinationCoordinate
        ride.user = User.currentUser
        
        DataManager.shared.save()
        
        self.showSimpleAlert(title: "Ride created!", message: "The ride was succesfully created ;)")
    }
}

extension OfferRideViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        drawPin(at: textField.text!) { (placemark) in
            switch textField {
            case self.originTextField:
                self.sourceMark = placemark
            case self.destinationTextField:
                self.destinationMark = placemark
            default:
                break
            }
            
            if self.sourceMark != nil && self.destinationMark != nil {
                self.drawRoute()
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
        renderer.lineWidth = 2.0
        
        return renderer
    }
    
}

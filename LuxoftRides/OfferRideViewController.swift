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

enum MarkType {
    case source, destination
}

class OfferRideViewController: UIViewController {
    
    var sourceMark: MKPlacemark?
    var destinationMark: MKPlacemark?
    
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    fileprivate lazy var sourceAnnotation: MKPointAnnotation = {
        return MKPointAnnotation()
    }()
    
    fileprivate lazy var destinationAnnotation: MKPointAnnotation = {
        return MKPointAnnotation()
    }()
    
    fileprivate var currentOverlay: MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func drawPin(at address: String, type: MarkType, completion: @escaping (MKPlacemark?) -> Void) {
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
                
                // Remove existing annotation on update
                switch type {
                case .source:
                    if self.sourceMark != nil {
                        self.mapView.removeAnnotation(self.sourceMark!)
                    }
                case .destination:
                    if self.destinationMark != nil {
                        self.mapView.removeAnnotation(self.destinationMark!)
                    }
                 }
                
                var region = self.mapView.region
                let mark = MKPlacemark(placemark: placemark)
                
                region.center = location.coordinate
                region.span.longitudeDelta /= 8.0
                region.span.latitudeDelta /= 8.0
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(mark)
                
                // Remove existing annotation on update
                /*switch type {
                case .source:
                    if self.sourceMark != nil {
                        self.mapView.removeAnnotation(self.sourceMark!)
                    }
                    self.sourceMark = mark
                case .destination:
                    if self.destinationMark != nil {
                        self.mapView.removeAnnotation(self.destinationMark!)
                    }
                    self.destinationMark = mark
                }*/
                
                completion(mark)
            }
        }
    }
    
    func removePreviousRoute() {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    func drawRoute() {
        guard let sourcePlacemark = sourceMark, let destinationPlacemark = destinationMark else { return }
        
        guard let sourceLocation = sourcePlacemark.location, let destinationLocation = destinationPlacemark.location else {
            return
        }
        
        self.sourceAnnotation.title = "Source"
        self.sourceAnnotation.coordinate = sourceLocation.coordinate
        
        self.destinationAnnotation.title = "Destination"
        self.destinationAnnotation.coordinate = destinationLocation.coordinate

        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
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
            let newOverlay = route.polyline
            self.mapView.add(newOverlay, level: MKOverlayLevel.aboveRoads)
            
            if let oldOverlay = self.currentOverlay {
                self.mapView.remove(oldOverlay)
            }
            self.currentOverlay = route.polyline
            
            let rect = newOverlay.boundingMapRect
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
        //self.removePreviousRoute()
        let type: MarkType = textField === originTextField ? .source : .destination
        
        drawPin(at: textField.text!, type: type) { (placemark) in
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

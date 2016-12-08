//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by smg on 24/10/16.
//  Copyright © 2016 smg. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit


class NotificationViewController: UIViewController, UNNotificationContentExtension, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
   
    let locationManager = CLLocationManager()

    var atmAnnotations = Array<MKPointAnnotation>()
    
    var userLocationFinded = false
    let someDoubleFormat = ".2"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

        let firstATMLocation = MKPointAnnotation()
        firstATMLocation.title = "Gebze"
        firstATMLocation.coordinate = CLLocationCoordinate2D(latitude: 40.796798, longitude: 29.440146)
        atmAnnotations.append(firstATMLocation)
        
        let secondATMLocation = MKPointAnnotation()
        secondATMLocation.title = "Gebze Medicalpark"
        secondATMLocation.coordinate = CLLocationCoordinate2D(latitude: 40.810518, longitude: 29.395207)
        atmAnnotations.append(secondATMLocation)
        
        
        let thirdATMLocation = MKPointAnnotation()
        thirdATMLocation.title = "İsmetpaşa Şube 1"
        thirdATMLocation.coordinate = CLLocationCoordinate2D(latitude: 40.791445, longitude: 29.414115)
        atmAnnotations.append(thirdATMLocation)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    
        mapView.addAnnotation(firstATMLocation)
        mapView.addAnnotation(secondATMLocation)
        mapView.addAnnotation(thirdATMLocation)
    }


    func didReceive(_ notification: UNNotification) {
        
    }

    func didReceive(_ response: UNNotificationResponse,
                    completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        completion(.dismissAndForwardAction)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        if(!userLocationFinded) {
            userLocationFinded = true
            
            let currentLocation = locations[0]
            let currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1))
            
            mapView.setRegion(currentRegion, animated: true)
            
            if(atmAnnotations.count > 0) {
                
                var minDistance: Double = -1.0
                var closestAtmAnnotation = MKPointAnnotation()
                
                for atmAnnotation in atmAnnotations {
                    let location = CLLocation(latitude: atmAnnotation.coordinate.latitude, longitude: atmAnnotation.coordinate.longitude)
                    let calculatedDistance = currentLocation.distance(from: location)
                    
                    if(minDistance == -1.0 || minDistance > calculatedDistance) {
                        minDistance = calculatedDistance
                        closestAtmAnnotation = atmAnnotation
                    }
                }
                
                mapView.selectAnnotation(closestAtmAnnotation, animated: false)
                
                
                let sourcePlacemark = MKPlacemark(coordinate: closestAtmAnnotation.coordinate, addressDictionary: nil)
                let destinationPlacemark = MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil)
                
                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                
                let directionRequest = MKDirectionsRequest()
                directionRequest.source = sourceMapItem
                directionRequest.destination = destinationMapItem
                directionRequest.transportType = .automobile
                
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
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
     
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

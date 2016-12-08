//
//  MapViewController.swift
//  SMG Rich Push Tester
//
//  Created by smg on 02/11/16.
//  Copyright © 2016 smg. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate,  CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let someDoubleFormat = ".2"
    
    var atmAnnotations = Array<MKPointAnnotation>()
    
    var firstATMLocation : MKPointAnnotation?
    var secondATMLocation : MKPointAnnotation?
    var thirdATMLocation : MKPointAnnotation?
    var userLocationFinded = false
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootControl = false
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        
        if(CLLocationManager.authorizationStatus() == .notDetermined) {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
        if firstATMLocation != nil {
            mapView.addAnnotation(firstATMLocation!)
            atmAnnotations.append(firstATMLocation!)
        }
        if secondATMLocation != nil {
            mapView.addAnnotation(secondATMLocation!)
            atmAnnotations.append(secondATMLocation!)
        }
        if thirdATMLocation != nil {
            mapView.addAnnotation(thirdATMLocation!)
            atmAnnotations.append(thirdATMLocation!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        if(!userLocationFinded) {
            userLocationFinded = true
            
            currentLocation = locations[0]
            
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
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedAnnotation = view.annotation as? MKPointAnnotation {
            
            mapView.isUserInteractionEnabled = false
            mapView.removeOverlays(mapView.overlays)

            let sourcePlacemark = MKPlacemark(coordinate: selectedAnnotation.coordinate, addressDictionary: nil)
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
                
                mapView.isUserInteractionEnabled = true
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                let route = response.routes[0]
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                if let detailCalloutAccessoryView = view.detailCalloutAccessoryView {
                    
                    if detailCalloutAccessoryView.subviews.count == 2 {
                        if let label1 = detailCalloutAccessoryView.subviews[0] as? UILabel {
                            label1.text = "Distance: \((route.distance / 1000).format(f: self.someDoubleFormat)) km"
                        }
                        if let label2 = detailCalloutAccessoryView.subviews[1] as? UILabel {
                            label2.text = "Time: \((route.expectedTravelTime / 60).format(f: ".0") ) minutes \(route.expectedTravelTime.truncatingRemainder(dividingBy: 60).format(f: ".0")) second"
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
           
            let multiLineView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
            
            let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 10))
            label1.font = label1.font.withSize(10)
            multiLineView.addSubview(label1)
            
            let label2 = UILabel(frame: CGRect(x: 0, y: 15, width: 150, height: 10))
            label2.font = label2.font.withSize(10)
            multiLineView.addSubview(label2)
            
            annotationView!.detailCalloutAccessoryView = multiLineView
            
            let widthConstraint = NSLayoutConstraint(item: multiLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            multiLineView.addConstraint(widthConstraint)
            
            let heightConstraint = NSLayoutConstraint(item: multiLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
            multiLineView.addConstraint(heightConstraint)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentControlChanged(_ sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1: mapView.mapType = .satellite
        case 2: mapView.mapType = .hybrid
        default: mapView.mapType = .standard
        }
    }

    @IBAction func showTrafficButtonPressed(_ sender: AnyObject) {
        mapView.showsTraffic = !mapView.showsTraffic
        
        if mapView.showsTraffic == true {
            sender.setTitle("Hide Traffic", for: UIControlState.normal)
        } else {
            sender.setTitle("Show Traffic", for: UIControlState.normal)
        }
    }
    
    @IBAction func showCompassButtonPressed(_ sender: AnyObject) {
        mapView.showsCompass = !mapView.showsCompass
        
        if mapView.showsCompass == true {
            sender.setTitle("Hide Compass", for: UIControlState.normal)
        } else {
            sender.setTitle("Show Compass", for: UIControlState.normal)
        }

    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


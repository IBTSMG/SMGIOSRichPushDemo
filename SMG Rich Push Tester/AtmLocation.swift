//
//  AtmLocation.swift
//  SMG Rich Push Tester
//
//  Created by smg on 03/11/16.
//  Copyright © 2016 smg. All rights reserved.
//

import Foundation
import MapKit

class AtmLocation {
    var annotation : MKPointAnnotation
    var distance : Double = 0
    
    init(latitude : Double, longitude : Double, title : String, userLocation : CLLocation) {
        annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        annotation.title = title
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        distance = userLocation.distance(from: location)
    }
}

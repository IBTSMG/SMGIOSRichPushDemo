//
//  NotificationHandler.swift
//  SMG Rich Push Tester
//
//  Created by smg on 16/08/16.
//  Copyright © 2016 smg. All rights reserved.
//

import UIKit
import UserNotifications
import MapKit

enum UserNotificationType: String {
    case media
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let options: UNNotificationPresentationOptions
        options = [.alert, .badge, .sound]

        completionHandler(options)
    }
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        if response.notification.request.content.categoryIdentifier == "myNotificationCategory" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewStoryboard") as! MapViewController
            let userLocation = CLLocation(latitude: 40.792193, longitude: 29.467080)

            let firstAtmLocation = AtmLocation(latitude: response.notification.request.content.userInfo["firstLatitude"] as! Double, longitude: response.notification.request.content.userInfo["firstLongitude"] as! Double, title: (response.notification.request.content.userInfo["firstTitle"] as? String)!, userLocation: userLocation)
            
            let secondAtmLocation = AtmLocation(latitude: response.notification.request.content.userInfo["secondLatitude"] as! Double, longitude: response.notification.request.content.userInfo["secondLongitude"] as! Double, title: (response.notification.request.content.userInfo["secondTitle"] as? String)!, userLocation: userLocation)
            
            let thirdAtmLocation = AtmLocation(latitude: response.notification.request.content.userInfo["thirdLatitude"] as! Double, longitude: response.notification.request.content.userInfo["thirdLongitude"] as! Double, title: (response.notification.request.content.userInfo["thirdTitle"] as? String)!, userLocation: userLocation)
            
            
            var atmLocations : [AtmLocation] = [firstAtmLocation, secondAtmLocation, thirdAtmLocation]
            atmLocations.sort(by: { $0.distance < $1.distance })
            
            if response.actionIdentifier == ActionType.goClosestATM.rawValue {
                mapViewController.firstATMLocation = atmLocations[0].annotation
            } else if response.actionIdentifier == ActionType.goSecondATM.rawValue {
                mapViewController.secondATMLocation = atmLocations[1].annotation
            } else if response.actionIdentifier == ActionType.goThirdATM.rawValue {
               mapViewController.thirdATMLocation = atmLocations[2].annotation
            } else {
                mapViewController.firstATMLocation = atmLocations[0].annotation
                mapViewController.secondATMLocation = atmLocations[1].annotation
                mapViewController.thirdATMLocation = atmLocations[2].annotation
            }
            
            appDelegate.window?.rootViewController = mapViewController

        }
  
        completionHandler()
    }
}


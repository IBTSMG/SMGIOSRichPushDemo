//
//  ViewController.swift
//  SMG Rich Push Tester
//
//  Created by smg on 16/08/16.
//  Copyright © 2016 smg. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

class ViewController: UIViewController {

    @IBAction func locatinButtonPressed(_ sender: AnyObject) {
        
        let content = UNMutableNotificationContent()
        content.title = "ATM Locations"
        content.body = "Closest ATM Location"
        
        content.userInfo["firstLatitude"] = 40.796798
        content.userInfo["firstLongitude"] = 29.440146
        content.userInfo["firstTitle"] = "Gebze"
        
        content.userInfo["secondLatitude"] = 40.810518
        content.userInfo["secondLongitude"] = 29.395207
        content.userInfo["secondTitle"] = "Gebze Medicalpark"
        
        content.userInfo["thirdLatitude"] = 40.791445
        content.userInfo["thirdLongitude"] = 29.414115
        content.userInfo["thirdTitle"] = "İsmetpaşa Şube 1"
        
        content.categoryIdentifier = "myNotificationCategory"

        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = "myNotificationCategory"
        
    
       
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                print("Location Notification scheduled: \(requestIdentifier)")
            }
        }

    }
    
    
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "Video Notification"
        content.body = "Istanbul"
        content.subtitle = "Show me a video!"
        //content.categoryIdentifier = NotificationType.plain.rawValue
        
        if let imageURL = Bundle.main.url(forResource: "Kiz Kulesi Istanbul", withExtension: "mp4"),
            let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
        {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = UserNotificationType.media.rawValue
        
        // The request describes this notification.
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                print("Video Notification scheduled: \(requestIdentifier)")
            }
        }
    }
    
    
    @IBAction func imageButtonPressed(_ sender: AnyObject) {
        
        let content = UNMutableNotificationContent()
        content.title = "Image Notification"
        content.body = "Kız Kulesi"
        content.subtitle = "İstanbul"
        
        if let imageURL = Bundle.main.url(forResource: "istanbul-kiz-kulesi", withExtension: "jpg"),
            let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
        {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = UserNotificationType.media.rawValue
        
        // The request describes this notification.
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                print("Image Notification scheduled: \(requestIdentifier)")
            }
        }
    }
    
    
    @IBAction func gifButtonPressed(_ sender: UIButton) {
        
        let content = UNMutableNotificationContent()
        content.title = "Gif Notification"
        content.body = "World"
        content.subtitle = "Show me a gif"
        
        if let gifURL = Bundle.main.url(forResource: "Rotating_earth_(large)", withExtension: "gif"),
            let attachment = try? UNNotificationAttachment(identifier: "gifAttachment", url: gifURL, options: nil)
        {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = UserNotificationType.media.rawValue
        
        // The request describes this notification.
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                print("Gif Notification scheduled: \(requestIdentifier)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootControl = true
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


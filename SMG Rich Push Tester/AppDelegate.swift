//
//  AppDelegate.swift
//  SMG Rich Push Tester
//
//  Created by smg on 16/08/16.
//  Copyright © 2016 smg. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    var rootControl = false;
    let locationManager = CLLocationManager()

    
    let notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        registerPushNotifications()
        
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        let goClosestATMAction = UNNotificationAction(identifier: ActionType.goClosestATM.rawValue, title: "Go to Closest ATM", options: UNNotificationActionOptions.foreground)
        
        let goSecondATMAction = UNNotificationAction(identifier: ActionType.goSecondATM.rawValue, title: "Go to Second ATM", options: UNNotificationActionOptions.foreground)
        
        let goThirdATMAction = UNNotificationAction(identifier: ActionType.goThirdATM.rawValue, title: "Go to Third ATM", options: UNNotificationActionOptions.foreground)
        
        let mapCategory = UNNotificationCategory(identifier: "myNotificationCategory", actions: [goClosestATMAction, goSecondATMAction, goThirdATMAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories(Set([mapCategory]))
        
        return true
    }
  
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func registerPushNotifications() {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            if(CLLocationManager.authorizationStatus() == .notDetermined) {
                self.locationManager.requestAlwaysAuthorization()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = (deviceToken as NSData).hexadecimalString
        print(deviceTokenString)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        completionHandler(.noData)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if(rootControl == false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainStoryboard") as! ViewController
            self.window?.rootViewController = mainViewController
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
extension NSData {
    
    /// Return hexadecimal string representation of NSData bytes
    @objc(kdj_hexadecimalString)
    public var hexadecimalString: NSString {
        var bytes = [UInt8](repeating: 0, count: length)
        getBytes(&bytes, length: length)
        
        let hexString = NSMutableString()
        for byte in bytes {
            hexString.appendFormat("%02x", UInt(byte))
        }
        
        return NSString(string: hexString)
    }
}

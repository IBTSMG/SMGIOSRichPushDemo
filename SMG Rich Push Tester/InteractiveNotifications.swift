//
//  InteractiveNotifications.swift
//  SMG Rich Push Tester
//
//  Created by smg on 19/08/16.
//  Copyright © 2016 smg. All rights reserved.
//

import Foundation
import UserNotifications

enum InteractiveNotifications: String {
    case Follow = "follow"
    case Read = "read"
    case Save = "save"
    
    private func title() -> String {
        switch self {
        case .Follow:
            return "Follow for Updates"
        case .Read:
            return "Read Story"
        case .Save:
            return "Save for Later"
        }
    }
    
    /**
     Three notification actions used for interactive notifications here just as examples. This is functionality introduced in iOS 8, not new to iOS 10 however the object types have changed from `UIUserNotificationAction` to the new `UNNotificationAction`. Everything else about how this functions is the same.
     */
    func action() -> UNNotificationAction {
        var options: UNNotificationActionOptions = []
        
        switch self {
        case .Read:
            options = [.foreground]
        default:
            break
        }
        
        return UNNotificationAction(identifier: self.rawValue, title: self.title(), options: options)
    }
}

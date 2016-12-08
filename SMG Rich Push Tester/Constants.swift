//
//  Constants.swift
//  SMG Rich Push Tester
//
//  Created by smg on 19/08/16.
//  Copyright © 2016 smg. All rights reserved.
//

import Foundation

enum NotificationType: String {
    case serviceExtension = "notificationServiceExtensionId"
    case contentExtension = "notificationContentExtensionId"
    case map = "myNotificationCategory"
}

enum ActionType: String {
    case goClosestATM = "GoClosestATM"
    case goSecondATM = "GoSecondATM"
    case goThirdATM = "GoThirdATM"
}


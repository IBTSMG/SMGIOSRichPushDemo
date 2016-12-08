//  NotificationService.swift
//  Created by smg on 17/08/16.
//  Copyright © 2016 smg. All rights reserved.

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
        
            if let contentId = bestAttemptContent.userInfo["content-id"] as? String {
                var url = URL(string: "")

                switch contentId {
                    
                case "URL":
                    url = URL(string: "YOUR_URL")
                    
                default:
                    url = URL(string: "DEFAULT_URL")
                }
                
                downloadFile(url: url!) { localURL in
                    if let localURL = localURL {
                        do {
                            let attachment = try UNNotificationAttachment(identifier: "gif", url: localURL, options: nil)
                            bestAttemptContent.attachments = [attachment]
                        } catch {
                            print(error)
                        }
                    }
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    private func downloadFile(url: URL, handler: @escaping (_ localURL: URL?) -> Void){
        //  if the file doesn't exist
        //  just download the data from your url
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
            // after downloading your data you need to save it to your destination url
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let location = location, error == nil
                else { return }
            do {
                let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                // your destination file url
                let destination = documentsUrl.appendingPathComponent(url.lastPathComponent)
                try FileManager.default.moveItem(at: location, to: destination)
                handler(destination)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }).resume()
    }
    
}


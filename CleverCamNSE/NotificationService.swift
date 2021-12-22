//
//  NotificationService.swift
//  CleverCamNSE
//
//  Created by Abhinandan Prateek on 14/12/21.
//

import UIKit
import UserNotifications
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if bestAttemptContent != nil {
            // Modify the notification content here...
            Messaging.serviceExtension().populateNotificationContent(self.bestAttemptContent!, withContentHandler: contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    

}

//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Abhinandan Prateek on 11/12/21.
//


import UserNotifications
import Firebase
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    //MARK : - Default notification will be modified with-in didReceive
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        print(">>>>>>>>>>>>NotificationService didReceive ")
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            guard let body = bestAttemptContent.userInfo["fcm_options"] as? Dictionary<String, Any>, let imageUrl = body["image"] as? String else { fatalError("Image Link not found") }
            downloadImageFrom(url: imageUrl) { (attachment) in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                    // Modify the notification content here...
                    bestAttemptContent.title = "\(bestAttemptContent.title) [Modified]"
//                  bestAttemptContent.categoryIdentifier = "myNotificationCategory"  // Comment it for now
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }
  
    //MARK: - If with-in 30 seconds didReceive can't modify the notification this method will be called
    override func serviceExtensionTimeWillExpire() {
        print(">>>>>>>>>>>>NotificationService serviceExtensionTimeWillExpire ")
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func downloadImageFrom(url: String, handler: @escaping (UNNotificationAttachment?) -> Void) {
        print(">>>>>>>>>>>>downloadImageFrom")
        let task = URLSession.shared.downloadTask(with: URL(string: url)!) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else { handler(nil) ; return } // RETURNING NIL IF IMAGE NOT FOUND
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueUrlEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueUrlEnding)
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            do {
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                handler(attachment) // RETURNING ATTACHEMENT HAVING THE IMAGE URL SUCCESSFULLY
            } catch {
                print("attachment error")
                    handler(nil)
                }
            }
            task.resume()
    }
}

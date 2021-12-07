//
//  PushNotificationManager.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 14/10/21.
//

import Firebase
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    static var fcmRegistered: Bool = false
    
    init(userID: String) {
        self.userID = userID
        super.init()
    }

    func registerForPushNotifications() {
        if (!PushNotificationManager.fcmRegistered){
            FirebaseApp.configure()
            FirebaseConfiguration.shared.setLoggerLevel(.min)
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
                // For iOS 10 data message (sent via FCM)
                Messaging.messaging().delegate = self
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }

            UIApplication.shared.registerForRemoteNotifications()
            updateFirestorePushTokenIfNeeded()
            PushNotificationManager.fcmRegistered = true
        }
    }

    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            HttpRequest.sendFCMToken(self, strToken: token) { (response) in
                print(response)
            }
            print("updateFirestorePushTokenIfNeeded",token)
        }
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print(">>>>>>messaging", remoteMessage)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(">>>>>>>>>messaging", fcmToken!)
        Users.setFCMtoken(object: fcmToken!)
    }

    /**
     [AnyHashable("comment"): , AnyHashable("google.c.sender.id"): 524484730347, AnyHashable("created"): 2021/12/07 11:28:26, AnyHashable("google.c.a.e"): 1, AnyHashable("title"): Bell button pressed on SmartCam, AnyHashable("image"): https://s3-us-west-2.amazonaws.com/data.ibeyonde/3d84dbe8/2021/12/07/11_28_15/vujH7N.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAYLP7ZL2EE452B26Y%2F20211207%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20211207T055827Z&X-Amz-SignedHeaders=host&X-Amz-Expires=14400&X-Amz-Signature=74a06fd1851ebd3b343fda2e8ea6e4e97cdbb76dc3b9c6b494ee29081c3dd177, AnyHashable("gcm.notification.type"): bp, AnyHashable("gcm.message_id"): 1638856710817406, AnyHashable("type"): bp, AnyHashable("uuid"): 3d84dbe8, AnyHashable("aps"): {
         alert =     {
             body = "2021/12/07 11:28:26";
             title = "Bell button pressed on SmartCam";
         };
     }, AnyHashable("value"): 0, AnyHashable("id"): 536219, AnyHashable("google.c.fid"): c-LofvfXKUUwrwTmkidgXe, AnyHashable("name"): SmartCam]

     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(">>>>>userNotificationCenter", response.notification.request.content.userInfo)
        
        let created = response.notification.request.content.userInfo["created"]!
        let image_url = response.notification.request.content.userInfo["image_url"]!
        let uuid = response.notification.request.content.userInfo["uuid"]!
        
        
        print(created)
        print(image_url)
        print(uuid)
        
        completionHandler()
    }
    
    
}


extension PushNotificationManager: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            print("Error in registering push notification")
        }
    }

}

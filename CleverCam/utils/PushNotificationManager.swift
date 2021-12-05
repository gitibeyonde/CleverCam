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
    
    init(userID: String) {
        self.userID = userID
        super.init()
    }

    func registerForPushNotifications() {
        FirebaseApp.configure()
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
    }

    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            //let usersRef = Firestore.firestore().collection("users_table").document(userID)
            //usersRef.setData(["fcmToken": token], merge: true)
            HttpRequest.sendFCMToken(self, strToken: token) { (response) in
                print(response)
            }
            print("updateFirestorePushTokenIfNeeded",token)
        }
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print(remoteMessage)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter", response)
    }
}


extension PushNotificationManager: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            print("Error in registering push notifcation")
        }
    }

}

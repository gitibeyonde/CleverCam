//
//  AppDelegate.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.notification.data"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(">>>>>>>>>didFinishLaunchingWithOptions willPresent----")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print(">>>>>>>>>didRegisterForRemoteNotificationsWithDeviceToken " , deviceToken.hexString)
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        print(">>>>>>>>>applicationDidFinishLaunching----")
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound]
          ) {(accepted, error) in
            if !accepted {
              print("Notification access denied.")
            }
          }
          UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(">>>>>>>>>didReceiveRemoteNotification", userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
                    print("Message ID: \(messageID)")
                }
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(">>>>>>>didReceiveRemoteNotification fetchCompletionHandler ",userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print(">>>>>>messaging", remoteMessage)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(">>>>>>>>>messaging", fcmToken!)
        Users.setFCMtoken(object: fcmToken!)
        print("Firebase registration token: \(fcmToken ?? "")")

        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    

}


extension AppDelegate : UNUserNotificationCenterDelegate {
    
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print(">>>>>>>>>userNotificationCenter willPresent----", notification.request.content.userInfo)
    let userInfo = notification.request.content.userInfo
    print(userInfo)
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    completionHandler([.banner, .list, .sound])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    print(">>>>>userNotificationCenter didReceive ----")
    let created: String = response.notification.request.content.userInfo["created"] as! String
    //let image = response.notification.request.content.userInfo["image"]!
    let uuid:String = response.notification.request.content.userInfo["uuid"] as! String
    
    
    print(created)
    //print(image)
    print(uuid)
    print(response.notification.request.content.userInfo)
    
    let viewController = UIApplication.shared.windows.first!.rootViewController as! ViewController
    
    DeviceViewController.showBell = true
    NotificationViewController.showBell = true
    BellAlertViewController.uuid = uuid
    BellAlertViewController.datetime = created
    print("Date time", BellAlertViewController.datetime)
    
    viewController.performSegue(withIdentifier: "ShowBell", sender: nil)
    print("Perform Segue ShowBell")
    
    completionHandler()
  }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


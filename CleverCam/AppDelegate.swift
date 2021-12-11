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
        FirebaseConfiguration.shared.setLoggerLevel(.max)

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
        UNUserNotificationCenter.current().delegate = self
        return true
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
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print(">>>>>>>>>didRegisterForRemoteNotificationsWithDeviceToken " , deviceToken)
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
    //let created = response.notification.request.content.userInfo["created"]!
    //let image = response.notification.request.content.userInfo["image"]!
    //let uuid = response.notification.request.content.userInfo["uuid"]!
    
    
    //print(created)
    //print(image)
    //print(uuid)
    print(response.notification.request.content.userInfo)
    
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    print(">>>>>userNotificationCenter Pop up  storyboard ----", storyboard.hashValue)
    // instantiate the view controller we want to show from storyboard
    // root view controller is tab bar controller
    // the selected tab is a navigation controller
    // then we push the new view controller to it
    let conversationVC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController
    print(">>>>>>>>>Got notification controller", conversationVC?.hashValue as Any)
    let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
    print(">>>>>>>>>Got tab bar controller", tabBarController?.hashValue as Any)
    DispatchQueue.main.async {
        tabBarController?.selectedViewController = tabBarController?.viewControllers![2]
    }
    
    completionHandler()
  }
}



//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Abhinandan Prateek on 07/12/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var img_notification: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        
        print("NotificationViewController didReceive")
        
        let attachmentURL = notification.request.content.userInfo["image"] as? String
        if attachmentURL != nil {
            let data = try? Data(contentsOf: URL(string: attachmentURL ?? "https://udp1.ibeyonde.com/img/no_image.jpg")!)
            if data != nil {
                self.img_notification.image = UIImage(data: data!)
            }
        }
    }

}

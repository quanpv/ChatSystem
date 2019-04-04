//
//  CSDemoNotify.swift
//  ChatSystem
//
//  Created by bit on 4/4/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit
import UserNotifications

class CSDemoNotify: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        // #1.1 - Create "the notification's category value--its type."
        let chatSystemdNotifCategory = UNNotificationCategory(identifier: "chatSystemNotification", actions: [], intentIdentifiers: [], options: [])
        // #1.2 - Register the notification type.
        UNUserNotificationCenter.current().setNotificationCategories([chatSystemdNotifCategory])
        self.addTarget(self, action: #selector(demoNotify(_:)), for: .touchUpInside)
    }
    
    @objc func demoNotify(_ sender: Any) {
        // find out what are the user's notification preferences
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else {
                let alert = UIAlertController(title: "Notification is turn off!", message: "Please turn on in setting app.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                    
                }))
                DispatchQueue.main.sync {
                    CSDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            let alert = UIAlertController(title: "Wait in 10 second!", message: "Auto exit app for receive demo notification.", preferredStyle: .alert)
            DispatchQueue.main.sync {
                CSDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 7, execute: {
                alert.dismiss(animated: true, completion: {
                    exit(0)
                })
            })
            // create the content and style for the local notification
            let content = UNMutableNotificationContent()
            
            if #available(iOS 12.0, *) {
                let hiddenPreviewsPlaceholder = "%u new message available"
                let summaryFormat = "%u more message of %@"
                let chatSystemCategory = UNNotificationCategory(identifier: "chatSystemNotification" , actions: [], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: hiddenPreviewsPlaceholder, categorySummaryFormat: summaryFormat, options: [])
                UNUserNotificationCenter.current().setNotificationCategories([chatSystemCategory])
                
            } else {
                // #2.1 - "Assign a value to this property that matches the identifier
                // property of one of the UNNotificationCategory objects you
                // previously registered with your app."
                content.categoryIdentifier = "chatSystemNotification"
            }
            
            // create the notification's content to be presented
            // to the user
            content.title = "CHAT SYSTEM NOTICE!"
            content.subtitle = "From CS"
            content.body = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"
            content.sound = UNNotificationSound.default
            content.badge = (content.badge?.intValue ?? 0  + 1) as NSNumber
            
            
            
            
            // #2.2 - create a "trigger condition that causes a notification
            // to be delivered after the specified amount of time elapses";
            // deliver after 10 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            // create a "request to schedule a local notification, which
            // includes the content of the notification and the trigger conditions for delivery"
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            // "Upon calling this method, the system begins tracking the
            // trigger conditions associated with your request. When the
            // trigger condition is met, the system delivers your notification."
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        } // end getNotificationSettings
    }

}

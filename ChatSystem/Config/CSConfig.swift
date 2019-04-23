//
//  MSConfig.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit
import UserNotifications

let CSDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: - Color
let barTintColor = UIColor(red: 253/255.0, green: 243/255.0, blue: 208/255.0, alpha: 1)
let tintColor = UIColor.black
let tintAttributeColor = UIColor.black
let barStyle = UIBarStyle.default
let ourselfBackgroundColor = UIColor.lightGray
let someoneElseBackgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)

//MARK: - Font
let systemFontSize = UIFont.systemFontSize
func fontRegular(size: CGFloat = systemFontSize) -> UIFont? {
    return UIFont(name: "Helvetica", size: size)
}
func fontLight(size: CGFloat = systemFontSize) -> UIFont? {
    return UIFont(name: "Helvetica-Light", size: size)
}
func fontMedium(size: CGFloat = systemFontSize) -> UIFont? {
    return UIFont(name: "Helvetica-Medium", size: size)
}
func fontBold(size: CGFloat = systemFontSize) -> UIFont? {
    return UIFont(name: "Helvetica-Bold", size: size)
}

// MARK: - Notification name
let kNotificationApplicationDidBecomeActive = NSNotification.Name("applicationDidBecomeActive")

//MARK: - Track debug
var dateFormatterTrack: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat =  "yyyy-MM-dd hh:mm:ssSSS"
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
}
func track(file: String = #file,
           function: String = #function,
           line: Int = #line,
           _ item: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let components = file.components(separatedBy: "/")
    print("\(dateFormatterTrack.string(from: Date())) [\(components.isEmpty ? "" : components.last!)][\(function)][\(line)]" , item, separator: separator, terminator: terminator)
    #endif
}

func trackRequest(_ item: Any..., separator: String = "\n", terminator: String = "\n") {
    #if DEBUG
    print("\(dateFormatterTrack.string(from: Date())) ------------------------------>" , item, separator: separator, terminator: terminator)
    #endif
}

func trackResponse(_ item: Any..., separator: String = "\n", terminator: String = "\n") {
    #if DEBUG
    print("\(dateFormatterTrack.string(from: Date())) <------------------------------" , item, separator: separator, terminator: terminator)
    #endif
}

// MARK: - RPC Service
let accountService = "account"
let groupService = "group"
let heartbeatService = "heartbeat"

// MARK: - Define for canculate id serial
let APP_ID_BITS: Int = 8
let SEQUENCE_BITS: Int = 14
//static long TIMESTAMP_BITS = 41;
let APP_ID_MASK: Int = 255 // (1L << APP_ID_BITS) - 1L;
let SEQUENCE_MASK: Int = 16383 //(1L << SEQUENCE_BITS) - 1L;
let TIMESTAMP_MASK: Int =  2199023255551//(1L << TIMESTAMP_BITS) - 1L;
let TIMESTAMP_OFFSET: Int = 1388505600000

//MARK: - Class config common
class CSConfig: NSObject {
    override init() {
        super.init()
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:tintAttributeColor]
        
        UISearchBar.appearance().backgroundColor = barTintColor
        
        // iOS 12 support
        if #available(iOS 12, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound, .provisional, .providesAppNotificationSettings, .criticalAlert]){ (granted, error) in
                if granted {
                    track("Notifications permission granted.")
                }
                else {
                    track("Notifications permission denied because: \(error?.localizedDescription ?? "unknow").")
                }
            }
            registerForRemoteNotifications()
        }
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ [weak self](granted, error) in
                if granted {
                    track("Notifications permission granted.")
                    self?.registerForRemoteNotifications()
                }
                else {
                    track("Notifications permission denied because: \(error?.localizedDescription ?? "unknow").")
                }
            }
        }
    }
    
    func registerForRemoteNotifications() {
        
    }
}

extension CSConfig: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let navController = CSDelegate.window?.rootViewController as! UINavigationController
        let settingsVC = CSSettingViewController()
        navController.pushViewController(settingsVC, animated: true)
    }
}

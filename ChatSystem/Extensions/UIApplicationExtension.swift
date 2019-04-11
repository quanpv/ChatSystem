//
//  UIApplicationExtension.swift
//  ChatSystem
//
//  Created by bit on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static let appVersion: String = getInfo("CFBundleShortVersionString") as? String ?? "1.0.0"
    static let buildVersion: String = getInfo("CFBundleVersion") as? String ?? "1.0.0"
    static let storeUrl: URL? = URL.init(string: getInfo("StoreURL") as? String ?? "")
    static let connectionTimeOut: Double = (getInfo("TimeOut") as? NSNumber)?.doubleValue ?? 15.0
    static let socketHost: String = getInfo("SocketHost") as? String ?? ""
    static let socketPort: UInt32 = (getInfo("SocketPort") as? NSNumber)?.uint32Value ?? 0
    static let sslPeerName: String = getInfo("SslPeerName") as? String ?? ""
    
    static func getInfo(_ key: String) -> Any? {
        return Bundle.main.infoDictionary?[key]
    }
    
}

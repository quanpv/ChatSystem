//
//  UIApplicationExtension.swift
//  ChatSystem
//
//  Created by bit on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    static let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0.0"
    static let storeUrl: URL? = URL.init(string: Bundle.main.infoDictionary?["StoreURL"] as? String ?? "")
    static let connectionTimeOut: Double = (Bundle.main.infoDictionary?["TimeOut"] as? NSNumber)?.doubleValue ?? 15.0
    static let socketHost: String = Bundle.main.infoDictionary?["SocketHost"] as? String ?? ""
    static let socketPort: UInt32 = (Bundle.main.infoDictionary?["SocketPort"] as? NSNumber)?.uint32Value ?? 0
    static let sslPeerName: String = Bundle.main.infoDictionary?["SslPeerName"] as? String ?? ""
    
}

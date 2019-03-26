//
//  UIApplicationExtension.swift
//  ChatSystem
//
//  Created by bit on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static let appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildVersion: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let storeUrl: URL? = URL.init(string: Bundle.main.infoDictionary?["StoreURL"] as? String ?? "")
    static let connectionTimeOut: Int? = (Bundle.main.infoDictionary?["TimeOut"] as? NSNumber)?.intValue
    
}

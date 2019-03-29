//
//  MSConfig.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

let CSDelegate = UIApplication.shared.delegate as! AppDelegate

let barTintColor = UIColor(red: 253/255.0, green: 243/255.0, blue: 208/255.0, alpha: 1)
let tintColor = UIColor.black
let tintAttributeColor = UIColor.black
let barStyle = UIBarStyle.default

class CSConfig {
    init() {
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:tintAttributeColor]
        
        UISearchBar.appearance().backgroundColor = barTintColor
    }
}

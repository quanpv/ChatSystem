//
//  MSConfig.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

let CSDelegate = UIApplication.shared.delegate as! AppDelegate

func dprint(_ item: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(item, separator: separator, terminator: terminator)
    #endif
}

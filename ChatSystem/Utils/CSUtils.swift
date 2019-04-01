//
//  CSUtils.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import Foundation

class Formatter {
    
    static let shared = Formatter()
    
    lazy var dateFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-mm-dd hh:mm"
        return df
    }()
    
    private init() { }
}

//
//  NSObjectExtension.swift
//  ChatSystem
//
//  Created by bit on 3/29/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import Foundation

extension NSObject {
    
    var dateFormatterLog: DateFormatter {
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
        print("\(dateFormatterLog.string(from: Date())) [\(components.isEmpty ? "" : components.last!)][\(function)][\(line)]" , item, separator: separator, terminator: terminator)
        #endif
    }
}


//
//  MessageModel.swift
//  ChatSystem
//
//  Created by bit on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

struct MessageModel {
    let message: String
    let senderUsername: String
    let messageSender: MessageSender
    let time: String
    let importanct: Bool
    
    init(message: String, messageSender: MessageSender, username: String, time: String, importanct: Bool = true) {
        self.message = message.withoutWhitespace()
        self.messageSender = messageSender
        self.senderUsername = username
        self.time = time
        self.importanct = importanct
    }
}

extension MessageModel: Equatable{
    static func ==(lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.message == rhs.message &&
            lhs.messageSender == rhs.messageSender &&
            lhs.senderUsername == rhs.senderUsername &&
            lhs.time == rhs.time &&
            lhs.importanct == rhs.importanct
    }
}

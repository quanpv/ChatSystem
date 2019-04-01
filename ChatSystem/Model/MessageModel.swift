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
    
    init(message: String, messageSender: MessageSender, username: String, time: String) {
        self.message = message.withoutWhitespace()
        self.messageSender = messageSender
        self.senderUsername = username
        self.time = time
    }
}

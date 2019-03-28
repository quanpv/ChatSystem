//
//  CSTalkRoomViewModel.swift
//  ChatSystem
//
//  Created by bit on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol TalkRoomView: class {
    func showMemberButton(isGroup:Bool)
    func showOnline(isOnline:Bool)
    func showFlag(isImportant:Bool)
    func updateDecreaseSend(enable:Bool)
    func updateDecreaseAttach(enable:Bool)
    func updateDecreaseCloseAttach(enable:Bool)
    func updateTable(messages:[MessageModel])
    func updateMessageCell(message:MessageModel, at index:IndexPath)
    func removeMessageCell(at index:IndexPath)
    func insertNewMessageCell(message:MessageModel)
    func setTextInputText(message:String)
}

class CSTalkRoomViewModel {//: CSNavigationViewModel {
    
    private weak var talkRoomView:TalkRoomView?
    public var messages = [MessageModel]()
    
    init() {
        
    }
    
    func attach(view:TalkRoomView) {
        self.talkRoomView = view
    }
    
    func joinChat(username: String) {
        CSSKConnection.shared.joinChat(username: username)
    }
    
    func send(message: String, action:ActionSend,at indexPath:IndexPath?) {
        if message.withoutWhitespace().count <= 0 {
            return
        }
        let messageModel = MessageModel(message: message, messageSender: .ourself, username: CSSKConnection.shared.username)
        
        switch action {
        case .new:
            messages.append(messageModel)
        case .edit:
            messages[indexPath!.row] = messageModel
        default:
            return
        }
        DispatchQueue.global().async {
            CSSKConnection.shared.sendMessage(message: message)
        }
        talkRoomView?.insertNewMessageCell(message: MessageModel(message: message, messageSender: .ourself, username: CSSKConnection.shared.username))
    }
    
    func update(message: String, at indexPath:IndexPath) {
        let messageModel = MessageModel(message: message, messageSender: .ourself, username: CSSKConnection.shared.username)
        messages[indexPath.row] = messageModel
        talkRoomView?.updateMessageCell(message: messageModel, at: indexPath)
    }
    
    func receivedMessage(message: MessageModel) {
        if message.messageSender != .ourself {
            messages.append(message)
            talkRoomView?.insertNewMessageCell(message: message)
        }
    }
    
    func deleteMessage(at indexPath:IndexPath) {
        messages.remove(at: indexPath.row)
        talkRoomView?.removeMessageCell(at: indexPath)
    }
}

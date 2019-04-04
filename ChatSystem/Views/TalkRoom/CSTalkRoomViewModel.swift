//
//  CSTalkRoomViewModel.swift
//  ChatSystem
//
//  Created by bit on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol CSTalkRoomViewModelProtocol: class {
//    @objc optional func showMemberButton(isGroup:Bool)
//    @objc optional func showOnline(isOnline:Bool)
//    @objc optional func showFlag(isImportant:Bool)
//    @objc optional func updateDecreaseSend(enable:Bool)
//    @objc optional func updateDecreaseAttach(enable:Bool)
//    @objc optional func updateDecreaseCloseAttach(enable:Bool)
//    @objc optional func setTextInputText(message:String)
    
    func updateCell(action: MessageAction, index: Int)
}

class CSTalkRoomViewModel: CSNavigationViewModel {
    
    private var messages: SynchronizedArray<MessageModel> = SynchronizedArray()
    
    public var numberOfRows: Int {
        return messages.count
    }    
    weak var delegate: CSTalkRoomViewModelProtocol?
    
    func setupDemoData() {
        var message = MessageModel(message: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", messageSender: .someoneElse, username: "Key", time: "2019-04-01 10:27")
        messages.append(message)
        message = MessageModel(message: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", messageSender: .someoneElse, username: "Tony", time: "2019-04-01 10:37")
        messages.append(message)
        message = MessageModel(message: " uis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", messageSender: .someoneElse, username: "Mat", time: "2019-04-01 10:39")
        messages.append(message)
        message = MessageModel(message: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", messageSender: .ourself, username: "me", time: "2019-04-01 10:40")
        messages.append(message)
    }
    
    func joinChat(username: String) {
        CSSKConnection.shared.joinChat(username: username)
    }
    
    // MARK: - Get message
    func message(at index:Int) -> MessageModel? {
        return messages[index]
    }
    
    // MARK: - Handle message
    func send(message: String, action:MessageAction,at indexPath:IndexPath?) {
        if message.withoutWhitespace().count <= 0 {
            return
        }
        let messageModel = MessageModel(message: message, messageSender: .ourself, username: CSSKConnection.shared.username, time: Formatter.shared.dateFormat.string(from: Date()))
        
        switch action {
        case .new:
            messages.append(messageModel)
            delegate?.updateCell(action: .new, index: messages.count - 1)
        case .edit:
            messages[indexPath!.row] = messageModel
            delegate?.updateCell(action: .edit, index: indexPath!.row)
        default:
            return
        }
        DispatchQueue.global().async {
            CSSKConnection.shared.sendMessage(message: message)
        }
    }
    
    func receivedMessage(message: MessageModel) {
        if message.messageSender != .ourself {
            messages.append(message)
            delegate?.updateCell(action: .new, index: messages.count - 1)
        }
    }
    
    func deleteMessage(at indexPath:IndexPath) {
        messages.remove(at: indexPath.row)
        delegate?.updateCell(action: .delete, index: indexPath.row)
    }
    
    // MARK: - Navigate
    func processOpenSearchMessage() {
        let searchMessage = CSSearchMessageViewController(nibName: CSSearchMessageViewController.className, bundle: nil)
        let nav = UINavigationController(rootViewController: searchMessage)
        self.ownerView?.present(nav, completion: nil)
    }
}

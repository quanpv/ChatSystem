//
//  CSTalkRoomViewController.swift
//  ChatSystem
//
//  Created by bit on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSTalkRoomViewController: CSBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let talkRoomVM = CSTalkRoomViewModel()
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override var inputAccessoryView: UIView? {
        return messageInputView
    }
    
    lazy var messageInputView: CSMessageInputView = {
        let accessoryView = CSMessageInputView()
        accessoryView.autoresizingMask = .flexibleHeight
        return accessoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputView.delegate = self
        becomeFirstResponder()
        
        talkRoomVM.attach(view: self)

        CSSKConnection.shared.closeSocket()
        CSSKConnection.shared.delegate = self
        CSSKConnection.shared.openSocket { [unowned self] (status) in
            if status == .opening {
                self.talkRoomVM.joinChat(username: "tampt")
            }
        }

        tableView.registerCellNib(CSTalkCell.self)

        loadViews()
    }
    
    func loadViews() {
        navigationItem.title = "Let's Chat!"
        navigationItem.backBarButtonItem?.title = "Run!"
        
        tableView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
    }
    
    func tableviewCellUpdate(action:(() -> Void)?) {
        let indexPath = IndexPath(row: talkRoomVM.messages.count - 1, section: 0)
        tableView.beginUpdates()
        action?()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: UITableViewDataSource
extension CSTalkRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talkRoomVM.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CSTalkCell") as! CSTalkCell
        cell.selectionStyle = .none
        cell.delegate = self
        let message = talkRoomVM.messages[indexPath.row]
        cell.apply(message: message, at: indexPath)
        
        return cell
    }
    
}

//MARK: UITableViewDelegate
extension CSTalkRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//MARK: Message Input Bar
extension CSTalkRoomViewController: MessageInputDelegate {
    func sendWasTapped(message: String, action: ActionSend, at indexPath: IndexPath?) {
        talkRoomVM.send(message: message, action:action, at:indexPath)
    }
}

//MARK: MessageDelegate
extension CSTalkRoomViewController: MessageDelegate {
    func receivedMessage(message: MessageModel) {
        talkRoomVM.receivedMessage(message: message)
    }
}

// MARK: TalkRoomView delegate
extension CSTalkRoomViewController:TalkRoomView {
    func showMemberButton(isGroup: Bool) {
        
    }
    
    func showOnline(isOnline: Bool) {
        
    }
    
    func showFlag(isImportant: Bool) {
        
    }
    
    func updateDecreaseSend(enable: Bool) {
        
    }
    
    func updateDecreaseAttach(enable: Bool) {
        
    }
    
    func updateDecreaseCloseAttach(enable: Bool) {
        
    }
    
    func updateTable(messages: [MessageModel]) {
        self.tableView.reloadData()
        tableviewCellUpdate(action: nil)
    }
    
    func updateMessageCell(message: MessageModel, at index: IndexPath) {
        tableviewCellUpdate(action: {
            self.tableView.reloadRows(at: [index], with: .bottom)
        })
    }
    
    func removeMessageCell(at index: IndexPath) {
        UIView.performWithoutAnimation {
            tableView.deleteRows(at: [index], with: .bottom)
        }
        tableView.reloadData()
    }
    
    func setTextInputText(message: String) {
//        messageInputView.textView.text = message
    }
    
    func insertNewMessageCell(message: MessageModel) {
        let indexPath = IndexPath(row: talkRoomVM.messages.count - 1, section: 0)
        tableviewCellUpdate(action: {
            self.tableView.insertRows(at: [indexPath], with: .bottom)
        })
    }
}

//MARK: CSTalkCellDelegate
extension CSTalkRoomViewController:CSTalkCellDelegate {
    func deleteMessage(at indexPath: IndexPath) {
        talkRoomVM.deleteMessage(at: indexPath)
    }
}

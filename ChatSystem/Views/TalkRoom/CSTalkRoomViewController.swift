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
        accessoryView.autoresizingMask = [.flexibleHeight]
        return accessoryView
    }()
    
    var isGroupTalk: Bool = false
    
    private let memberItem: UIBarButtonItem = UIBarButtonItem.init(title: "メンバ", style: .done, target: self, action: #selector(memberTap(sender:)))
    
    private let searchItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(searchTap(sender:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        track()
        talkRoomVM.attach(view: self)
        messageInputView.delegate = self
        becomeFirstResponder()
        
        tableView.registerCellNib(CSTalkCell.self)
        loadViews()
        setupDemoData()
    }
    
    func setupDemoData() {
        var mesage = MessageModel(message: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", messageSender: .someoneElse, username: "Key", time: "2019-04-01 10:27")
        talkRoomVM.messages.append(mesage)
        mesage = MessageModel(message: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", messageSender: .someoneElse, username: "Tony", time: "2019-04-01 10:37")
        talkRoomVM.messages.append(mesage)
        mesage = MessageModel(message: " uis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", messageSender: .someoneElse, username: "Mat", time: "2019-04-01 10:39")
        talkRoomVM.messages.append(mesage)
        mesage = MessageModel(message: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", messageSender: .ourself, username: "me", time: "2019-04-01 10:40")
        talkRoomVM.messages.append(mesage)
    }
    
    func loadViews() {
        navigationItem.title = "Let's Chat!"
        
        tableView.separatorStyle = .none
        
        if isGroupTalk {
            navigationItem.rightBarButtonItems = [searchItem, memberItem]
        } else {
            navigationItem.rightBarButtonItems = [searchItem]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        CSSKConnection.shared.delegate = self
        CSSKConnection.shared.openSocket { [unowned self] (status) in
            if status == .opening {
                self.talkRoomVM.joinChat(username: "tampt")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
        
        CSSKConnection.shared.closeSocket()
    }
    
    func tableviewCellUpdate(action:(() -> Void)?) {
        let indexPath = IndexPath(row: talkRoomVM.messages.count - 1, section: 0)
        tableView.beginUpdates()
        action?()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            let endHeight = endFrame.size.height
            UIView.animate(withDuration: 0.25) { [unowned self] in
                self.tableView.contentInset.bottom = endHeight
                self.tableView.scrollIndicatorInsets.bottom = endHeight
            }
        }
    }
    
    @objc func memberTap(sender: Any) {
        
    }
    
    @objc func searchTap(sender: Any) {
        
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
        return 70
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

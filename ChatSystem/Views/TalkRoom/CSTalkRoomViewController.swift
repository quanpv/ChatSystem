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
        let rect = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 144)
        let accessoryView = CSMessageInputView(frame: rect)
        accessoryView.autoresizingMask = [.flexibleHeight]
        return accessoryView
    }()
    
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
        var mesage = MessageModel(message: "Hello", messageSender: .someoneElse, username: "Key")
        talkRoomVM.messages.append(mesage)
        mesage = MessageModel(message: "Hi", messageSender: .someoneElse, username: "Tony")
        talkRoomVM.messages.append(mesage)
        mesage = MessageModel(message: "Hi, welcome join", messageSender: .someoneElse, username: "Mat")
        talkRoomVM.messages.append(mesage)
        mesage = MessageModel(message: "Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. Hi every one. ", messageSender: .ourself, username: "me")
        talkRoomVM.messages.append(mesage)
    }
    
    func loadViews() {
        navigationItem.title = "Let's Chat!"
        navigationItem.backBarButtonItem?.title = "Run!"
        
        tableView.separatorStyle = .none
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
            UIView.animate(withDuration: 0.25) {
                self.tableView.contentInset.bottom = endHeight
            }
        }
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
        return 75
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

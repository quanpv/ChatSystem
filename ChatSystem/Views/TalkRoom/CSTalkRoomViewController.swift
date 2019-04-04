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
    
    lazy var messageInputView: CSMessageInputView = {
        let accessoryView = CSMessageInputView()
        accessoryView.autoresizingMask = [.flexibleHeight]
        return accessoryView
    }()
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? {
        return messageInputView
    }
    
    var viewModel: CSTalkRoomViewModel!
    
    var isGroupTalk: Bool = false
    
    private let memberItem: UIBarButtonItem = {
        let btnGroupMember = UIButton.init(type: .custom)
        btnGroupMember.titleLabel?.textColor = UIColor.white
        btnGroupMember.setTitle("メンバ", for: .normal)
        btnGroupMember.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        btnGroupMember.backgroundColor = UIColor.blue
        btnGroupMember.layer.cornerRadius = 4
        //        btnGroupMember.layer.borderWidth = 0.5
        btnGroupMember.clipsToBounds = true
        //        btnGroupMember.layer.borderColor = UIColor.red.cgColor
        btnGroupMember.frame = CGRect(x:0,y: 0, width:60, height:20)
        btnGroupMember.addTarget(self, action: #selector(memberTap(sender: )), for: .touchUpInside)
        let groupItem = UIBarButtonItem(customView: btnGroupMember);
        return groupItem
    }()
    
    private let searchItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(searchTap(sender:)))
    
    // MARK: Life cycle view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        track()
        
        viewModel.delegate = self
        messageInputView.delegate = self
        becomeFirstResponder()
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellNib(CSTalkCell.self)
        viewModel.setupDemoData()
        tableView.reloadData()
        
        loadViews()
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
                self.viewModel.joinChat(username: "me")
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
    
    // MARK: UI
    func loadViews() {
        tableviewCellUpdate(nil)
        if isGroupTalk {
            navigationItem.rightBarButtonItems = [searchItem, memberItem]
        } else {
            navigationItem.rightBarButtonItems = [searchItem]
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            let endHeight = endFrame.size.height
            if let duration = userInfo[UIView.keyboardAnimationDurationUserInfoKey] as? NSNumber,
                let curve = userInfo[UIView.keyboardAnimationCurveUserInfoKey] as? NSNumber {
                UIView.animate(withDuration: duration.doubleValue,
                               delay: 0,
                               options: UIView.AnimationOptions(rawValue: curve.uintValue),
                               animations: {
                                self.tableView.contentInset.bottom = endHeight
                                self.tableView.scrollIndicatorInsets.bottom = endHeight
                }, completion: nil)
            }
            if Int(endHeight) == Int(inputAccessoryView?.frame.size.height ?? 52) {
                return
            }
            self.scrollToBottom(animated: true)
        }
    }
    
    func tableviewCellUpdate(_ action:(() -> Void)?) {
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.beginUpdates()
            action?()
            tableView.endUpdates()
            scrollToBottom(animated: true)
        }
    }
    
    private func scrollToBottom(animated: Bool = true) {
        let numberOfRows = tableView.numberOfRows(inSection: tableView.numberOfSections - 1)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: tableView.numberOfSections - 1)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    // MARK: UI action
    @objc func memberTap(sender: Any) {
        let groupMember = CSGroupMemberViewController(nibName: CSGroupMemberViewController.className, bundle: nil)
        self.show(groupMember)
    }
    
    @objc func searchTap(sender: Any) {
        viewModel.processOpenSearchMessage()
    }
}

// MARK: - Talk Cell Delegate
extension CSTalkRoomViewController: CSTalkCellDelegate {
    func deleteMessage(at indexPath: IndexPath) {
        viewModel.deleteMessage(at: indexPath)
    }
}

// MARK: - Message Input Bar delegate
extension CSTalkRoomViewController: MessageInputDelegate {
    func sendWasTapped(message: String, action: MessageAction, at indexPath: IndexPath?) {
        viewModel.send(message: message, action:action, at:indexPath)
    }
}

// MARK: - Message Delegate
extension CSTalkRoomViewController: MessageDelegate {
    func receivedMessage(message: MessageModel) {
        viewModel.receivedMessage(message: message)
    }
}

// MARK: - Table view datasource
extension CSTalkRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSTalkCell.className) as! CSTalkCell
        cell.selectionStyle = .none
        cell.delegate = self
        if let message = viewModel.message(at: indexPath.row) {
            cell.apply(message: message, at: indexPath)
        }
        
        return cell
    }
}

// MARK: - Table view delegate
extension CSTalkRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSTalkCell.height(for: viewModel.message(at: indexPath.row)!)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CSTalkCell.height(for: viewModel.message(at: indexPath.row)!)
    }
}

// MARK: - Talk Room ViewModel Protocol
extension CSTalkRoomViewController: CSTalkRoomViewModelProtocol {
    func updateCell(action: MessageAction, index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        switch action {
        case .new:
            tableviewCellUpdate { [weak self] in
                self?.tableView.insertRows(at: [indexPath], with: .none)}
        case .edit:
            tableviewCellUpdate { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .none)}
        case .delete:
            tableView.reloadData()
        default:
            break
        }
    }
}


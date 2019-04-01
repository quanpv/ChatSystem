//
//  CSTalkCell.swift
//  ChatSystem
//
//  Created by bit on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

let widthControl: CGFloat = 25.0

protocol CSTalkCellDelegate: class {
    func deleteMessage(at indexPath:IndexPath)
}

class CSTalkCell: UITableViewCell {

    var messageSender: MessageSender = .ourself
    weak var delegate:CSTalkCellDelegate?
    private var indexPath:IndexPath = IndexPath()
    var statusSender: StatusSender = .online
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLabel: CSLabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var stackContainer: UIStackView!
    
    @IBOutlet weak var widthLabel: NSLayoutConstraint!
    @IBOutlet weak var heightLabel: NSLayoutConstraint!
    
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont(name: "Helvetica", size: 14)
        
        time.textColor = .lightGray
        time.font = UIFont(name: "Helvetica", size: 12)
        
        clipsToBounds = true
        nameLabel.isHidden = true
        avatar.isHidden = true
        deleteButton.isHidden = true
        flag.isHidden = true
        
        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(-widthControl, after: messageLabel)
        } else {
            // Fallback on earlier versions
            flag.translatesAutoresizingMaskIntoConstraints = false
            flag.heightAnchor.constraint(equalToConstant: widthControl).isActive = true
            flag.widthAnchor.constraint(equalToConstant: widthControl).isActive = true
            flag.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: -widthControl).isActive = true
            
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.heightAnchor.constraint(equalToConstant: widthControl).isActive = true
            deleteButton.widthAnchor.constraint(equalToConstant: widthControl).isActive = true
            deleteButton.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: -widthControl).isActive = true
        }
    }
    
    func apply(message: MessageModel, at indexPath:IndexPath) {
        self.indexPath = indexPath
        nameLabel.text = message.senderUsername
        messageLabel.text = message.message
        messageSender = message.messageSender
        time.text = message.time
        
        if messageSender == .ourself {
            nameLabel.isHidden = true
            messageLabel.backgroundColor = .lightGray
            avatar.isHidden = true
            deleteButton.isHidden = false
            stackContainer.alignment = .trailing
            
            status.isHidden = true
            time.textAlignment = .right
        } else {
            nameLabel.isHidden = false
            nameLabel.sizeToFit()
            messageLabel.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
            avatar.isHidden = false
            deleteButton.isHidden = true
            stackContainer.alignment = .leading
            
            status.isHidden = statusSender == .offline
            time.textAlignment = .left
        }
        layoutIfNeeded()
    }
    
    @IBAction func deleteTap(_ sender: Any) {
        delegate?.deleteMessage(at: indexPath)
    }
}

// MARK: layout
extension CSTalkCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isJoinMessage() {
            layoutForJoinMessage()
        } else {
            messageLabel.font = UIFont(name: "Helvetica", size: 17)
            messageLabel.textColor = .white
            
            let size = messageLabel.sizeThatFits(CGSize(width: 3*(bounds.size.width/5), height: CGFloat.greatestFiniteMagnitude))
            heightLabel.constant = size.height + 16
            widthLabel.constant = size.width + 32
        }
        
        messageLabel.layer.cornerRadius = min(heightLabel.constant/2.0, 16)
    }
    
    func layoutForJoinMessage() {
        nameLabel.isHidden = true
        messageLabel.font = UIFont.systemFont(ofSize: 10)
        messageLabel.textColor = .lightGray
        messageLabel.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        avatar.isHidden = true
        deleteButton.isHidden = true
        stackContainer.alignment = .center
        
        let size = messageLabel.sizeThatFits(CGSize(width: 2*(bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude))
        heightLabel.constant = size.height + 16
        widthLabel.constant = size.width + 32
    }
    
    func isJoinMessage() -> Bool {
        if let words = messageLabel.text?.components(separatedBy: " ") {
            if words.count >= 2 && words[words.count - 2] == "has" && words[words.count - 1] == "joined" {
                return true
            }
        }
        
        return false
    }
}

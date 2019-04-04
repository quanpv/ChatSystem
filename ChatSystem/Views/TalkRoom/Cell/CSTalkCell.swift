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
    
    @IBOutlet weak var stackContainer: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackMessage: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLabel: CSLabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var widthLabel: NSLayoutConstraint!
    @IBOutlet weak var heightLabel: NSLayoutConstraint!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    private static let fontSizeMessageLabel: CGFloat = systemFontSize
    private static let fontSizeNameLabel: CGFloat = 14
    private static let fontSizeTimeLabel: CGFloat = 12
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.font = fontRegular(size: CSTalkCell.fontSizeMessageLabel)
        
        nameLabel.textColor = .darkGray
        nameLabel.font = fontRegular(size: CSTalkCell.fontSizeNameLabel)
        nameLabel.isHidden = true
        
        time.textColor = .lightGray
        time.font = fontRegular(size: CSTalkCell.fontSizeTimeLabel)
        
        clipsToBounds = true
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
    
    public func apply(message: MessageModel, at indexPath:IndexPath) {
        self.indexPath = indexPath
        nameLabel.text = message.senderUsername
        messageLabel.text = message.message
        messageSender = message.messageSender
        time.text = message.time
        
        if messageSender == .ourself {
            nameLabel.isHidden = true
            messageLabel.backgroundColor = ourselfBackgroundColor
            avatar.isHidden = true
            deleteButton.isHidden = false
            stackContainer.alignment = .trailing
            stackMessage.alignment = .trailing
            status.isHidden = true
            time.textAlignment = .right
        } else {
            nameLabel.isHidden = false
            nameLabel.sizeToFit()
            messageLabel.backgroundColor = someoneElseBackgroundColor
            avatar.isHidden = false
            deleteButton.isHidden = true
            stackContainer.alignment = .leading
            stackMessage.alignment = .leading
            status.isHidden = statusSender == .offline
            time.textAlignment = .left
        }
        setNeedsLayout()
    }
    
    @IBAction func deleteTap(_ sender: Any) {
        delegate?.deleteMessage(at: indexPath)
    }
}

// MARK: - Layout
extension CSTalkCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isJoinMessage() {
            layoutForJoinMessage()
        } else {
            layoutForMessage()
        }
        messageLabel.layer.cornerRadius = min(heightLabel.constant/2.0, 16)
    }
    
    private func layoutForMessage() {
        let size = messageLabel.sizeThatFits(CGSize(width: 3 * (CSDelegate.window!.bounds.size.width / 5), height: CGFloat.greatestFiniteMagnitude))
        heightLabel.constant = size.height + 16
        widthLabel.constant = size.width + 32
    }
    
    private func layoutForJoinMessage() {
        nameLabel.isHidden = true
        messageLabel.font = UIFont.systemFont(ofSize: 10)
        messageLabel.textColor = .lightGray
        messageLabel.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        avatar.isHidden = true
        deleteButton.isHidden = true
        stackContainer.alignment = .center
        
        let size = messageLabel.sizeThatFits(CGSize(width: 3 * (CSDelegate.window!.bounds.size.width / 5), height: CGFloat.greatestFiniteMagnitude))
        heightLabel.constant = size.height + 16
        widthLabel.constant = size.width + 32
    }
    
    private func isJoinMessage() -> Bool {
        if let words = messageLabel.text?.components(separatedBy: " ") {
            if words.count >= 2 && words[words.count - 2] == "has" && words[words.count - 1] == "joined" {
                return true
            }
        }
        
        return false
    }
    
    class func height(for message: MessageModel) -> CGFloat {
        let maxSize = CGSize(width: 3 * (CSDelegate.window!.bounds.size.width / 5), height: CGFloat.greatestFiniteMagnitude)
        let nameHeight = message.messageSender == .ourself ? 0 : (height(forText: message.senderUsername, fontSize: fontSizeNameLabel, maxSize: maxSize) + 4 )
        let messageHeight = height(forText: message.message, fontSize: fontSizeMessageLabel, maxSize: maxSize)
        let timeHeight = height(forText: message.time, fontSize: fontSizeTimeLabel, maxSize: maxSize)
        
        return nameHeight + messageHeight + timeHeight + 16 + 16 + 2 + 2 // 16 for message inset; 16 for margin content cell; 2 for 2 stack spacing
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: fontRegular(size: fontSize)!,
                                                                      NSAttributedString.Key.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }
}

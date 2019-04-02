//
//  CSSearchMessageCell.swift
//  ChatSystem
//
//  Created by bit on 4/1/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSSearchMessageCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var messageLabel: CSLabel!
    @IBOutlet weak var flag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageLabel.clipsToBounds = true
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.font = UIFont(name: "Helvetica", size: 17)
        messageLabel.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
        messageLabel.textColor = .white
        messageLabel.layer.cornerRadius = 16
    }

    func apply(message: MessageModel) {
        messageLabel.text = message.message
        name.text = message.senderUsername
        time.text = message.time
        flag.isHidden = !message.importanct
    }
}

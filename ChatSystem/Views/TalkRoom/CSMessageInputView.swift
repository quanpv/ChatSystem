//
//  CSMessageInputView.swift
//  ChatSystem
//
//  Created by bit on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

enum ActionSend {
    case none, new, edit
}

protocol MessageInputDelegate {
    func sendWasTapped(message:String, action:ActionSend, at indexPath:IndexPath?)
}

class CSMessageInputView: UIView {
    
    var delegate: MessageInputDelegate?
    var editIndexPath: IndexPath?
    
    let identifier = "CSMessageInputView"
    let maximumNumberOfLines:CGFloat = 5
    let defaultHeightTextView: CGFloat = 40
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundColor = UIColor.groupTableViewBackground
        textView.layer.cornerRadius = 4
        textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.6).cgColor
        textView.layer.borderWidth = 1
        
        textView.textContainer.maximumNumberOfLines = Int(maximumNumberOfLines)
        layoutTextView()
        textView.delegate = self
        
        sendButton.backgroundColor = UIColor(red: 8/255, green: 183/255, blue: 231/255, alpha: 1.0)
        sendButton.layer.cornerRadius = 4
        sendButton.isEnabled = true
        
        sendButton.addTarget(self, action: #selector(CSMessageInputView.sendTapped), for: .touchUpInside)
    }
    
    @objc func sendTapped() {
        if let delegate = delegate, let message = textView.text {
            delegate.sendWasTapped(message:  message, action: (editIndexPath != nil ? .edit : .new), at: editIndexPath)
            textView.text = ""
            layoutTextView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: font],
                                                 context: nil).size
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    func layoutTextView() {
        let boundingRect = sizeOfString(string: textView.text, constrainedToWidth: Double(textView.frame.width), font: textView.font!)
        let numberLines = boundingRect.height / textView.font!.lineHeight;
        if numberLines > maximumNumberOfLines {
            heightTextView.constant = textView.font!.lineHeight * maximumNumberOfLines
            textView.isScrollEnabled = true
        } else {
            heightTextView.constant = max(textView.font!.lineHeight * numberLines, defaultHeightTextView)
            textView.isScrollEnabled = false
        }
    }
}

extension CSMessageInputView: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        layoutTextView()
    }
}

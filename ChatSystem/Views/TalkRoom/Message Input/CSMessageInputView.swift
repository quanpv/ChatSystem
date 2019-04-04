//
//  CSMessageInputView.swift
//  ChatSystem
//
//  Created by bit on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol MessageInputDelegate {
    func sendWasTapped(message:String, action:MessageAction, at indexPath:IndexPath?)
}

class CSMessageInputView: UIView {
    
    var delegate: MessageInputDelegate?
    var editIndexPath: IndexPath?
    
    let identifier = "CSMessageInputView"
    let maximumNumberOfLines:CGFloat = 5
    lazy var defaultHeightTextView: CGFloat = {
        return textView.font!.lineHeight + textView.contentInset.top + textView.contentInset.bottom
    }()
    lazy var maxHeightTextView: CGFloat = {
        return textView.font!.lineHeight * maximumNumberOfLines + textView.contentInset.top + textView.contentInset.bottom
    }()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightButtonSend: NSLayoutConstraint!
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
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.layer.cornerRadius = 4
        textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.6).cgColor
        textView.layer.borderWidth = 0.5
        textView.delegate = self
        layoutTextView()
        
        sendButton.layer.cornerRadius = 4
        sendButton.isEnabled = true
        heightButtonSend.constant = defaultHeightTextView + textView.textContainerInset.top + textView.textContainerInset.bottom
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }
    
    @objc func sendTapped() {
        if let delegate = delegate, let message = textView.text {
            delegate.sendWasTapped(message:  message, action: (editIndexPath != nil ? .edit : .new), at: editIndexPath)
            textView.text = ""
            layoutTextView()
        }
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: font],
                                                 context: nil).size
    }
    
    private var previewHeight: CGFloat = 0
    
    func layoutTextView() {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        if newSize.height != previewHeight {
            if newSize.height >= maxHeightTextView {
                heightTextView.constant = maxHeightTextView
                textView.isScrollEnabled = true
            }
            else
            {
                heightTextView.constant = max(newSize.height, defaultHeightTextView)
                textView.isScrollEnabled = false
            }
            previewHeight = newSize.height
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}

// MARK: - Text view delegate
extension CSMessageInputView: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        layoutTextView()
    }
}

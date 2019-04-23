//
//  CSMemberTalkCell.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/28/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSMemberTalkCell: UITableViewCell {

    @IBOutlet weak var rationButton: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ room: RoomTest) {
      self.labelName.text = room.name
    }
    
    @IBAction func actionSelected(_ sender: UIButton) {
         self.rationButton.isSelected =  !sender.isSelected
    }
}

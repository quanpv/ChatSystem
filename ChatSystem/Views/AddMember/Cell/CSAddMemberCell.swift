//
//  CSGroupMemberCell.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 4/1/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSAddMemberCell: UITableViewCell {

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelJob: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionCheckBox(_ sender: Any) {
        self.btnCheckBox.isSelected =  !self.btnCheckBox.isSelected
    }
    
    func setData(_ data: GroupMemberModel) {
        labelId.text = data.id
        labelName.text = data.name
        labelJob.text = data.job
    }
}

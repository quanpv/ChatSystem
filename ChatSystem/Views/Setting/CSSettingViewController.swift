//
//  CSSettingViewController.swift
//  ChatSystem
//
//  Created by bit on 4/2/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSSettingViewController: CSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "設定"
    }

    @IBAction func hideConversation(_ sender: Any) {
        let hideRoom = CSHideRoomViewController(nibName: CSHideRoomViewController.className, bundle: nil)
        show(hideRoom)
    }
    
    @IBAction func notificationChanged(_ sender: Any) {
        
    }
}

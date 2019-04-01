//
//  CSTalkListViewModel.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSTalkListViewModel: CSNavigationViewModel {
    
    func processOpenCreateTalk() {
        let createTalk = CSCreateTalkViewController(nibName: CSCreateTalkViewController.className, bundle: nil)
        self.ownerView?.show(createTalk)
    }
    
    func processOpenTalkRoom(indexPath: IndexPath) {
        let talkRoom = CSTalkRoomViewController(nibName: CSTalkRoomViewController.className, bundle: nil)
        talkRoom.isGroupTalk = indexPath.row % 2 == 0
        self.ownerView?.show(talkRoom)
    }
}


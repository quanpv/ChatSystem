//
//  CSTalkListViewModel.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSTalkListViewModel: CSNavigationViewModel {
    
    func processOpenSetting() {
        let settings = CSSettingViewController(nibName: CSSettingViewController.className, bundle: nil)
        self.ownerView?.show(settings)
    }
    
    func processOpenCreateTalk() {
        let createTalk = CSCreateTalkViewController(nibName: CSCreateTalkViewController.className, bundle: nil)
        self.ownerView?.show(createTalk)
    }
    
    func processOpenCreateGroupTalk() {
        let createGroupTalk = CSCreateGroupTalkViewController(nibName: CSCreateGroupTalkViewController.className, bundle: nil)
        self.ownerView?.show(createGroupTalk)
    }
    
    func processOpenTalkRoom(indexPath: IndexPath) {
        let talkRoomVC = CSTalkRoomViewController(nibName: CSTalkRoomViewController.className, bundle: nil)
        let talkRoomVM = CSTalkRoomViewModel(talkRoomVC)
        talkRoomVC.viewModel = talkRoomVM
        talkRoomVC.isGroupTalk = indexPath.row % 2 == 0
        self.ownerView?.show(talkRoomVC)
    }
}


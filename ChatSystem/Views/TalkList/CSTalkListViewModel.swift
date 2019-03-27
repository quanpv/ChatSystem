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
        let view = CSCreateTalkViewController(nibName: CSCreateTalkViewController.className, bundle: nil)
        self.ownerView?.openView(view)
    }
}


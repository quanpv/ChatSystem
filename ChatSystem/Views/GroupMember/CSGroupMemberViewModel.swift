//
//  File.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 4/2/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSGroupMemberViewModel: CSNavigationViewModel {
    
    func processOpenAddMember() {
        let addMember = CSAddMemberViewController(nibName: CSAddMemberViewController.className, bundle: nil)
        self.ownerView?.show(addMember)
    }
}

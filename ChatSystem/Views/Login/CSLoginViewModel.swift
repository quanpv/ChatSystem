//
//  CSLoginViewModel.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol LoginViewModelProtocol {
    func openTalkListScreen()
}

class CSLoginViewModel: CSNavigationViewModel {
    
    func processOpenTalkList() {
        let view = CSTalkListViewController(nibName: CSTalkListViewController.className, bundle: nil)
        self.ownerView?.openView(view)
    }
}

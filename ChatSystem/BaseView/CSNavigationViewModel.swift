//
//  CSNavigationViewModel.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol CSNavigationViewModelProtocol {
    func openView(_ view: CSBaseViewController, animated: Bool)
    func selfClose(animated: Bool)
    func closeToRoot(animated: Bool)
    func closeToView(_ view: CSBaseViewController, animated: Bool)
}

class CSNavigationViewModel: CSBaseViewModel {
    func closeCurrent() {
        self.ownerView?.selfClose(animated: true)
    }
}

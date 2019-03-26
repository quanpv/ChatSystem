//
//  CSBaseViewModel.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSBaseViewModel: NSObject {
    
    var ownerView: CSBaseViewController?
    
    init(_ ownerView: CSBaseViewController) {
        self.ownerView = ownerView
    }
}

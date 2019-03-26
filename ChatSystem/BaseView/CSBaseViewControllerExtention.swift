//
//  CSBaseViewControllerExtention.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

//MARK: - Use for holding VC instead of using UINavigationController
class CSStackOfView {
    private var rootView: UIViewController?
    var stackOfViews: [UIViewController] = []
    
    init(_ rootView: CSBaseViewController) {
        self.rootView = rootView
    }
    
    func push(_ view: UIViewController) {
        stackOfViews.append(view)
    }
    
    func doPop() {
        if stackOfViews.count > 0 {
            let _ = stackOfViews.removeLast()
        }
    }
    
    func getPop() -> UIViewController{
        return stackOfViews.removeLast()
    }
    
    func getRoot() -> UIViewController {
        return rootView!
    }
    
    func getLast() -> UIViewController {
        if stackOfViews.count == 0 {
            return rootView!
        }
        return stackOfViews.last!
    }
}

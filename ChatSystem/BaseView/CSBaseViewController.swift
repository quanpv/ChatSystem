//
//  CSBaseViewController.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSBaseViewController: UIViewController, CSNavigationViewModelProtocol {

    private var viewHolder: CSStackOfView? // Root view will own this object
    var isStartedScreen: Bool { return false }
    var navigationVM: CSNavigationViewModel { return CSNavigationViewModel(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    deinit {
      
    }
    
    //MARK: - Setup viewHolder *IMPORTANT*
    func setupViewHolder() {
        if let _ = viewHolder {
            print("ViewHolder is not null, this is not Root View, dont need to initialize")
        } else {
            viewHolder = CSStackOfView(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MSNavigationVMProtocol
    func openView(_ view: CSBaseViewController, animated: Bool = true) {
        self.viewHolder?.push(view)
        view.viewHolder = self.viewHolder // new view will refer/point to this stack of view, to use later
        CSDelegate.window?.swapRootViewControllerWithAnimation(newViewController: view, animationType: .push)
    }
    
    func selfClose(animated: Bool = true) {
        self.viewHolder?.doPop()
        let newLastView = self.viewHolder?.getLast()
        CSDelegate.window?.swapRootViewControllerWithAnimation(newViewController: newLastView!, animationType: .pop)
    }
    
    func closeToRoot(animated: Bool = true) {
        let rootView = self.viewHolder?.getLast()
        CSDelegate.window?.swapRootViewControllerWithAnimation(newViewController: rootView!, animationType: .pop)
    }
    
    func closeToView(_ view: CSBaseViewController, animated: Bool = true) {
        //MARK: - TODO closeToView
    }
}

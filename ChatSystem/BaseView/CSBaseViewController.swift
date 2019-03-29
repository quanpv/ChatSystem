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
    var navigationVM: CSNavigationViewModel { return CSNavigationViewModel(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHolder()
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
    
    
    //MARK: Navigate
    
    func swapRoot(_ vc: UIViewController) {
        CSDelegate.window?.swapRoot(vc)
    }
    
    func swapRootNavigation(_ vc: UIViewController) {
        CSDelegate.window?.swapRootNavigation(vc)
    }
    
    func show(_ vc: UIViewController) {
        navigationController?.show(vc, sender: nil)
    }
    
    func present(_ vc: UIViewController, completion: (()->Void)?) {
        present(vc, animated: true, completion: completion)
    }
    
    func showDetailViewController(_ vc: UIViewController) {
        navigationController?.showDetailViewController(vc, sender: nil)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToViewController(_ vc: UIViewController) {
        navigationController?.popToViewController(vc, animated: true)
    }
    
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}

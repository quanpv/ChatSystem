//
//  CSBaseViewController.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if (self.responds(to: #selector(getter: UIViewController.edgesForExtendedLayout))) {
            self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
}

extension CSBaseViewController: CSNavigationViewModelProtocol {
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

extension CSBaseViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CSBaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

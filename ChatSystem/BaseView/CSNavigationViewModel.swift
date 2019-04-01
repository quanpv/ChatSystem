//
//  CSNavigationViewModel.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol CSNavigationViewModelProtocol {
    func show(_ vc: UIViewController)
    func present(_ vc: UIViewController, completion: (()->Void)?)
    func showDetailViewController(_ vc: UIViewController)
    func popViewController()
    func popToViewController(_ vc: UIViewController)
    func popToRootViewController()
}

class CSNavigationViewModel: CSBaseViewModel {
    
}

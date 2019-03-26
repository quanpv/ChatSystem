//
//  UIWindowExtension.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

// Ref: https://stackoverflow.com/a/43474135
public enum SwapRootViewControllerAnimationType {
    case push
    case pop
    case present
    case dismiss
}

extension UIWindow {
    
    public func swapRootViewControllerWithAnimation(newViewController: UIViewController, animationType: SwapRootViewControllerAnimationType, completion: (() -> ())? = nil)
    {
        guard let currentViewController = rootViewController else {
            return
        }
        
        if newViewController == rootViewController {
            return
        }
        
        let width = currentViewController.view.frame.size.width;
        let height = currentViewController.view.frame.size.height;
        
        var newVCStartAnimationFrame: CGRect?
        var currentVCEndAnimationFrame:CGRect?
        
        var newVCAnimated = true
        
        switch animationType
        {
        case .push:
            newVCStartAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            currentVCEndAnimationFrame = CGRect(x: 0 - width/4, y: 0, width: width, height: height)
        case .pop:
            currentVCEndAnimationFrame = CGRect(x: width, y: 0, width: width, height: height)
            newVCStartAnimationFrame = CGRect(x: 0 - width/4, y: 0, width: width, height: height)
            newVCAnimated = false
        case .present:
            newVCStartAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
        case .dismiss:
            currentVCEndAnimationFrame = CGRect(x: 0, y: height, width: width, height: height)
            newVCAnimated = false
        }
        
        newViewController.view.frame = newVCStartAnimationFrame ?? CGRect(x: 0, y: 0, width: width, height: height)
        
        addSubview(newViewController.view)
        
        if !newVCAnimated {
            bringSubviewToFront(currentViewController.view)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            if let currentVCEndAnimationFrame = currentVCEndAnimationFrame {
                currentViewController.view.frame = currentVCEndAnimationFrame
            }
            
            newViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }, completion: { finish in
            self.rootViewController = newViewController
            completion?()
        })
        
        makeKeyAndVisible()
    }
}


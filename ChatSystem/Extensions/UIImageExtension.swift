//
//  UIImageExtension.swift
//  ChatSystem
//
//  Created by bit on 4/2/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

extension UIImage {
    
    func image(with color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

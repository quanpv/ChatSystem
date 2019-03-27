//
//  CSCreateTalkViewController.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSCreateTalkViewController: CSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.responds(to: #selector(getter: UIViewController.edgesForExtendedLayout))) {
              self.edgesForExtendedLayout = []
        }
      
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width:  self.view.bounds.width, height: 45))
        self.view.addSubview(navBar)
        navBar.backgroundColor = UIColor.red
        let navItem = UINavigationItem(title: "News");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(actionBack));
        navItem.leftBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        // Do any additional setup after loading the view.
    }

    @objc func actionBack() {
        self.selfClose()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

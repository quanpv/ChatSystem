//
//  CSLoginViewController.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSLoginViewController: CSBaseViewController {

    var loginVM: CSLoginViewModel {
        return CSLoginViewModel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        track()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionLogin(_ sender: Any) {
        loginVM.processOpenTalkList()
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

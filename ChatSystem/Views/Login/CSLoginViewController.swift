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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        CSRpc.shared.stop()
        CSRpc.shared.start()
        print("okokkkkk")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func actionLogin(_ sender: Any) {
        var loginRequest = LoginRequest()
        loginRequest.loginID = "101"
        loginRequest.password = "yume123123"
        CSRpc.shared.login(with: loginRequest) { (result, response) in
            
        }
    }
    
    @IBAction func actionForgotPW(_ sender: Any) {
        CSRpc.shared.stop()
        loginVM.processOpenForgotPW()
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

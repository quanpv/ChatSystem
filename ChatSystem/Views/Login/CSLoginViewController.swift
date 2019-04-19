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
        let rpc = CSRpc()
        rpc.start()
        print("okokkkkk")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func actionLogin(_ sender: Any) {
        var loginRequest = LoginRequest()
        loginRequest.loginID = "1"
        loginRequest.password = "1"
        let rpc = CSRpc()
        rpc.rpcLogin(request: loginRequest) { (result, response) in
            track(result, response)
        }
//        loginVM.processOpenTalkList()
    }
    
    @IBAction func actionForgotPW(_ sender: Any) {
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

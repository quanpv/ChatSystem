//
//  CSSettingViewController.swift
//  ChatSystem
//
//  Created by bit on 4/2/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit
import UserNotifications

class CSSettingViewController: CSBaseViewController {

    @IBOutlet weak var notifySwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "設定"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStateNotify()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStateNotify), name: kNotificationApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func hideConversation(_ sender: Any) {
        let hideRoom = CSHideRoomViewController(nibName: CSHideRoomViewController.className, bundle: nil)
        show(hideRoom)
    }
    
    @IBAction func notificationChanged(_ sender: Any) {
        let alertController = UIAlertController (title: "For turn \(notifySwitch.isOn ? "on" : "off") notification", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    track("Settings opened: \(success)")
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self](_) in
            self.updateStateNotify()
        }
        alertController.addAction(cancelAction)
        
        present(alertController, completion: nil)
    }
    
    @objc func updateStateNotify() {
        UNUserNotificationCenter.current().getNotificationSettings { [unowned self](settings) in
            DispatchQueue.main.sync {
                self.notifySwitch.setOn((settings.authorizationStatus == .authorized), animated: true)
            }
        }
    }
}

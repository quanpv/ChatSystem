//
//  CSHideRoomViewController.swift
//  ChatSystem
//
//  Created by bit on 4/2/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSHideRoomViewController: CSBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var rooms: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "非表示ルーム"
        rooms = ["第一グループ", "02918 高橋太郎　給与"]
    }

}

extension CSHideRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = rooms[indexPath.row]
        
        return cell!
    }
}

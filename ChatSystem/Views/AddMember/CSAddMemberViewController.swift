//
//  CSAddMemberViewController.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 4/2/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSAddMemberViewController: CSBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var members = [GroupMemberModel(avatar: "Red Velvet", id: "02934", name: "高橋太郎", job: "営業"),
                   GroupMemberModel(avatar: "Red Velvet", id: "13954", name: "鈴木一郎", job: "給与"),
                   GroupMemberModel(avatar: "Red Velvet", id: "17374", name: "山下太郎", job: "人材開発"),
                   GroupMemberModel(avatar: "Red Velvet", id: "27367", name: "木下花子", job: "人材開発"),
                   GroupMemberModel(avatar: "Red Velvet", id: "12345", name: "hihi", job: "cuu van")]
    
    var filteredMembers = [GroupMemberModel]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "グループ追加"
        filteredMembers = members
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.registerCellNib(CSAddMemberCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }


    @IBAction func actionAddTo(_ sender: Any) {
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

extension CSAddMemberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

extension CSAddMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        var cell:CSAddMemberCell? = self.tableView.dequeueReusableCell(withIdentifier: CSAddMemberCell.className, for: indexPath) as? CSAddMemberCell
        if (cell == nil) {
            cell = CSAddMemberCell(style: .default, reuseIdentifier:
                CSAddMemberCell.className)
        }
        // set the text from the data model
        cell?.setData(filteredMembers[indexPath.row])
        
        return cell!
    }
    
}

extension CSAddMemberViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredMembers = members
        } else {
            // Filter the results
            filteredMembers = members.filter { $0.id.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
}

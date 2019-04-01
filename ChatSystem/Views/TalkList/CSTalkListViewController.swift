//
//  CSTalkListViewController.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSTalkListViewController: CSBaseViewController {
    
    @IBOutlet weak var tableViewTalkList: UITableView!
    
    var talkListVM: CSTalkListViewModel {
        return CSTalkListViewModel(self)
    }
    
    var rooms = [Room(name: "Red Velvet", date: "2019/01/11 11:30"),
                 Room(name: "Brownie", date: "2019/02/13 12:30"),
                 Room(name: "Bannna Bread", date: "2019/03/16 10:00"),
                 Room(name: "Vanilla", date: "2019/04/14 01:30"),
                 Room(name: "Minty", date: "2019/05/15 09:10")]
    
    var filteredRooms = [Room]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        track()
        
        filteredRooms = rooms
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableViewTalkList.tableHeaderView = searchController.searchBar
        
        self.tableViewTalkList.registerCellNib(CSTalkListCell.self)
        self.tableViewTalkList.delegate = self
        self.tableViewTalkList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionCreateTalk(_ sender: Any) {
        talkListVM.processOpenCreateTalk()
    }
    
    @IBAction func actionCreateGroupTalk(_ sender: Any) {
        talkListVM.processOpenCreateGroupTalk()
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

extension CSTalkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        talkListVM.processOpenTalkRoom(indexPath: indexPath)
    }
}

extension CSTalkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        var cell:CSTalkListCell? = self.tableViewTalkList.dequeueReusableCell(withIdentifier: CSTalkListCell.className, for: indexPath) as? CSTalkListCell
        if (cell == nil) {
            cell = CSTalkListCell(style: .default, reuseIdentifier:
                CSTalkListCell.className)
        }
        // set the text from the data model
        cell?.setData(filteredRooms[indexPath.row])
        
        return cell!
    }
}

extension CSTalkListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredRooms = rooms
        } else {
            // Filter the results
            filteredRooms = rooms.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableViewTalkList.reloadData()
    }
}

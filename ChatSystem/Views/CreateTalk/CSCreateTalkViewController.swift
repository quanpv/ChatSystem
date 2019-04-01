//
//  CSCreateTalkViewController.swift
//  ChatSystem
//
//  Created by Pham Van Quan on 3/27/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSCreateTalkViewController: CSBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
//        let heightStatusBar = UIApplication.shared.statusBarFrame.height
//        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: heightStatusBar, width:  self.view.bounds.width, height: 45))
//        self.view.addSubview(navBar)
//        navBar.backgroundColor = UIColor.cyan
//        let navItem = UINavigationItem(title: "トークルーム")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(actionBack));
//        navItem.leftBarButtonItem = doneItem;
//        navBar.setItems([navItem], animated: false);
        title = "トークルーム"
        // Do any additional setup after loading the view.
        filteredRooms = rooms
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.registerCellNib(CSMemberTalkCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    @objc func actionBack() {
        self.popViewController()
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

extension CSCreateTalkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}

extension CSCreateTalkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        var cell:CSMemberTalkCell? = self.tableView.dequeueReusableCell(withIdentifier: CSMemberTalkCell.className, for: indexPath) as? CSMemberTalkCell
        if (cell == nil) {
            cell = CSMemberTalkCell(style: .default, reuseIdentifier:
                CSMemberTalkCell.className)
        }
        // set the text from the data model
        cell?.setData(filteredRooms[indexPath.row])
        
        return cell!
    }
}

extension CSCreateTalkViewController:UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredRooms = rooms
        } else {
            // Filter the results
            filteredRooms = rooms.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
}

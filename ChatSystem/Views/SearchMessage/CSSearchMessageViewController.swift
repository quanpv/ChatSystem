//
//  CSSearchMessageViewController.swift
//  ChatSystem
//
//  Created by bit on 4/1/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSSearchMessageViewController: CSBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var searchMessageVM = CSSearchMessageViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    var messagesFiltered = [MessageModel]()
    var isSearching: Bool = false
    var cancelButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "10218 高橋太郎"
        let cancel = UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(cancelAction(_:)))
        navigationItem.leftBarButtonItem = cancel
        
        searchBar.placeholder = "検 索"
        searchBar.showsCancelButton = true
        searchBar.barTintColor = barTintColor
        for v in searchBar.subviews[0].subviews where v.isKind(of: UIButton.self) {
            cancelButton = v as? UIButton
        }
        cancelButton?.setTitle("", for: .normal)
        cancelButton?.setImage(UIImage(named: "unflag")!.withRenderingMode(.alwaysOriginal), for: .normal)
        cancelButton?.setImage(UIImage(named: "unflag")!.withRenderingMode(.alwaysOriginal), for: .highlighted)
        cancelButton?.setImage(UIImage(named: "flag")!.withRenderingMode(.alwaysOriginal), for: .selected)
        cancelButton?.tintColor = .clear
        definesPresentationContext = true
        tableView.tableHeaderView?.frame.size.height = searchBar.bounds.size.height
        tableView.registerCellNib(CSSearchMessageCell.self)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        searchMessageVM.setupDataDemo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    @objc func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func search(with searchBar: UISearchBar) {
        if cancelButton?.isSelected == true {
            isSearching = true
            if let searchText = searchBar.text, searchText.count > 0 {
                messagesFiltered = searchMessageVM.messages.filter {
                    $0.message.lowercased().contains(searchText.lowercased())
                        && $0.importanct == true
                }
            } else {
                messagesFiltered = searchMessageVM.messages.filter {
                    $0.importanct == true
                }
            }
        } else {
            if let searchText = searchBar.text, searchText.count > 0 {
                isSearching = true
                messagesFiltered = searchMessageVM.messages.filter {
                    $0.message.lowercased().contains(searchText.lowercased())
                }
            } else {
                isSearching = false
            }
        }
        
        tableView.reloadData()
    }

}

// MARK: table view datasource
extension CSSearchMessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? messagesFiltered.count : searchMessageVM.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSSearchMessageCell.className) as! CSSearchMessageCell
        cell.apply(message: isSearching ? messagesFiltered[indexPath.row] : searchMessageVM.messages[indexPath.row])
        
        return cell
    }
}

extension CSSearchMessageViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelButton?.isSelected = !cancelButton!.isSelected
        
        search(with: searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(with: searchBar)
        searchBar.endEditing(true)
    }
}

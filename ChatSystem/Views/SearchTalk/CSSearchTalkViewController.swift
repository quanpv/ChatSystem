//
//  CSSearchTalkViewController.swift
//  ChatSystem
//
//  Created by bit on 4/1/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSSearchTalkViewController: CSBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchTalkVM: CSSearchTalkViewModel!
    private let searchController = UISearchController(searchResultsController: nil)
    private var isFlaged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        searchTalkVM = CSSearchTalkViewModel(dataSource: ObservableDataSource<MessageModel>())
        tableView.dataSource = self
        tableView.delegate = self
        searchTalkVM?.dataSource.data.observe(observer: self) { [weak self](array) in
            self?.tableView.reloadData()
        }
        searchTalkVM?.setupDataDemo()
    }
    
    private func setupView() {
        extendedLayoutIncludesOpaqueBars = true
        title = "10218 高橋太郎"
        let cancel = UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(cancelAction(_:)))
        navigationItem.leftBarButtonItem = cancel
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "検 索"
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.delegate = self
        searchController.searchBar.setImage(UIImage(named: "unflag")!.withRenderingMode(.alwaysOriginal), for: .bookmark, state: .normal)
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.registerCellNib(CSSearchTalkCell.self)
        tableView.separatorStyle = .none
    }
    
    @objc func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CSSearchTalkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTalkVM?.search(with: searchController.searchBar.text, important: isFlaged)
    }
}

extension CSSearchTalkViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isFlaged = !isFlaged
        let unflag = UIImage(named: "unflag")!.withRenderingMode(.alwaysOriginal)
        let flag = UIImage(named: "flag")!.withRenderingMode(.alwaysOriginal)
        searchBar.setImage(isFlaged ? flag : unflag, for: .bookmark, state: .normal)
        searchTalkVM?.search(with: searchBar.text, important: isFlaged)
    }
}

extension CSSearchTalkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CSSearchTalkViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTalkVM.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSSearchTalkCell.className) as! CSSearchTalkCell
        if let message = searchTalkVM.message(at: indexPath.row) {
            cell.apply(message: message)
        }
        
        return cell
    }
}

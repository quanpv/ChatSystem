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
    
    var searchMessageVM: CSSearchMessageViewModel?
    private let searchController = UISearchController(searchResultsController: nil)
    private var isFlaged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        searchMessageVM = CSSearchMessageViewModel(dataSource: CSSearchMessageDataSource(), isImportant: isFlaged)
        tableView.dataSource = searchMessageVM?.dataSource
        tableView.delegate = self
        searchMessageVM?.dataSource?.messages.data.observe(observer: self) { [weak self](array) in
            self?.tableView.reloadData()
        }
        searchMessageVM?.setupDataDemo()
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
        tableView.registerCellNib(CSSearchMessageCell.self)
        tableView.separatorStyle = .none
    }
    
    @objc func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CSSearchMessageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchMessageVM?.search(with: searchController.searchBar)
    }
}

extension CSSearchMessageViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isFlaged = !isFlaged
        let unflag = UIImage(named: "unflag")!.withRenderingMode(.alwaysOriginal)
        let flag = UIImage(named: "flag")!.withRenderingMode(.alwaysOriginal)
        searchBar.setImage(isFlaged ? flag : unflag, for: .bookmark, state: .normal)
        searchMessageVM?.isImportant = isFlaged
        searchMessageVM?.search(with: searchBar)
    }
}

extension CSSearchMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

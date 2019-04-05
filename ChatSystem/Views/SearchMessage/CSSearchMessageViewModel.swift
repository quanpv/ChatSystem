//
//  CSSearchMessageViewModel.swift
//  ChatSystem
//
//  Created by bit on 4/1/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSSearchMessageViewModel {
    
    var dataSource: CSSearchMessageDataSource?
    private var messages = ObservableDataSource<MessageModel>()
    
    var isImportant:Bool!
    
    init(dataSource: CSSearchMessageDataSource, isImportant: Bool = false) {
        self.dataSource = dataSource
        self.isImportant = isImportant
    }
    
    public func setupDataDemo() {
        var message = MessageModel(message: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", messageSender: .someoneElse, username: "Key", time: "2019-04-01 10:27")
        messages.data.value.append(message)
        message = MessageModel(message: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", messageSender: .someoneElse, username: "Tony", time: "2019-04-01 10:37", importanct: false)
        messages.data.value.append(message)
        message = MessageModel(message: " uis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", messageSender: .someoneElse, username: "Mat", time: "2019-04-01 10:39")
        messages.data.value.append(message)
        message = MessageModel(message: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", messageSender: .ourself, username: "me", time: "2019-04-01 10:40", importanct: false)
        messages.data.value.append(message)
        dataSource?.messages.data.value = messages.data.value.copy()
    }
    
    func search(with searchBar: UISearchBar) {
        if isImportant == true {
            if let searchText = searchBar.text, searchText.count > 0 {
                dataSource?.messages.data.value = messages.data.value.filter {
                    $0.message.lowercased().contains(searchText.lowercased())
                        && $0.importanct == true
                }
            } else {
                dataSource?.messages.data.value = messages.data.value.filter {
                    $0.importanct == true
                }
            }
        } else {
            if let searchText = searchBar.text, searchText.count > 0 {
                dataSource?.messages.data.value = messages.data.value.filter {
                    $0.message.lowercased().contains(searchText.lowercased())
                }
            } else {
                dataSource?.messages.data.value = messages.data.value.copy()
            }
        }
    }
}

class CSSearchMessageDataSource: NSObject, UITableViewDataSource {
    var messages = ObservableDataSource<MessageModel>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSSearchMessageCell.className) as! CSSearchMessageCell
        cell.apply(message: messages.data.value[indexPath.row]!)
        
        return cell
    }
}

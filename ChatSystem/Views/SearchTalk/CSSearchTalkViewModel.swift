//
//  CSSearchTalkViewModel.swift
//  ChatSystem
//
//  Created by bit on 4/1/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

class CSSearchTalkViewModel {
    
    var dataSource: ObservableDataSource<MessageModel>!
    private var messages = SynchronizedArray<MessageModel>()
    
    init(dataSource: ObservableDataSource<MessageModel>) {
        self.dataSource = dataSource
        self.messages = dataSource.data.value
    }
    
    public func setupDataDemo() {
        messages = SynchronizedArray<MessageModel>()
        var message = MessageModel(message: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", messageSender: .someoneElse, username: "Key", time: "2019-04-01 10:27")
        messages.append(message)
        message = MessageModel(message: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", messageSender: .someoneElse, username: "Tony", time: "2019-04-01 10:37", importanct: false)
        messages.append(message)
        message = MessageModel(message: " uis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", messageSender: .someoneElse, username: "Mat", time: "2019-04-01 10:39")
        messages.append(message)
        message = MessageModel(message: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", messageSender: .ourself, username: "me", time: "2019-04-01 10:40", importanct: false)
        messages.append(message)
        dataSource?.data.value = messages.copy()
    }
    
    func numberOfRowsInSection() -> Int {
        return dataSource.data.value.count
    }
    
    func message(at index: Int) -> MessageModel? {
        return dataSource.data.value[index]
    }
    
    func search(with searchText: String?, important: Bool = false) {
        if important == true {
            if let searchText = searchText, searchText.count > 0 {
                dataSource.data.value = messages.filter {
                    $0.message.lowercased().contains(searchText.lowercased())
                        && $0.importanct == true
                }
            } else {
                dataSource.data.value = messages.filter {
                    $0.importanct == true
                }
            }
        } else {
            if let searchText = searchText, searchText.count > 0 {
                dataSource.data.value = messages.filter {
                    $0.message.lowercased().contains(searchText.lowercased())
                }
            } else {
                dataSource.data.value = messages.copy()
            }
        }
    }
}

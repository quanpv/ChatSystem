//
//  CSSearchTalkViewModelTests.swift
//  ChatSystemTests
//
//  Created by bit on 4/5/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import XCTest
@testable import ChatSystem_DEV

class CSSearchTalkViewMock:NSObject {
    var arrayData: SynchronizedArray<MessageModel>!
    
    init(viewModel: CSSearchTalkViewModel) {
        super.init()
        
        viewModel.dataSource.data.observe(observer: self, handler: { [weak self](messages) in
            self?.arrayData = messages
        })
    }
}

class CSSearchTalkViewModelTests: XCTestCase {
    
    var viewModel:CSSearchTalkViewModel!
    var viewMock:CSSearchTalkViewMock!
    var dataSource:ObservableDataSource<MessageModel>!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataSource = ObservableDataSource<MessageModel>()
        var messageModel = MessageModel(message: "aa", messageSender: .someoneElse, username: "Mat", time: "2019-04-05 23:23", importanct: true)
        dataSource.data.value.append(messageModel)
        messageModel = MessageModel(message: "ab", messageSender: .someoneElse, username: "May", time: "2019-04-05 23:33", importanct: false)
        dataSource.data.value.append(messageModel)
        messageModel = MessageModel(message: "ac", messageSender: .someoneElse, username: "Take", time: "2019-04-05 23:43", importanct: false)
        dataSource.data.value.append(messageModel)
        messageModel = MessageModel(message: "bc", messageSender: .someoneElse, username: "Tor", time: "2019-04-05 23:53", importanct: true)
        dataSource.data.value.append(messageModel)
        viewModel = CSSearchTalkViewModel(dataSource: dataSource)
        viewMock = CSSearchTalkViewMock(viewModel: viewModel)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        viewMock = nil
        dataSource = nil
    }
    
    func testNumberOfRowsInSection() {
        XCTAssert(viewModel.numberOfRowsInSection() == 4, "testNumberOfRowsInSection")
    }
    
    func testMessageAtIndex0() {
        let message = viewModel.message(at: 0)
        let messageMock = dataSource.data.value[0]
        XCTAssertEqual(message, messageMock)
    }
    
    func testSetupDataDemo() {
        viewModel.setupDataDemo()
        XCTAssert(viewMock.arrayData.count == 4, "testSetupDataDemo")
    }
    
    func testSearchEmptySearchTextAndFlagFalse() {
        viewModel.search(with: "")
        XCTAssert(viewMock.arrayData.count == 4, "testSearch_EmptySearchTextAndFlagFalse_ReturnElementCountIsFour")
    }
    
    func testSearchTextIsAAndFlagFalse() {
        viewModel.search(with: "a")
        XCTAssert(viewMock.arrayData.count == 3, "testSearch_TextIsAAndFlagFalse_ReturnElementCountIsThree")
    }
    
    func testSearchTextIsEmptyAndFlagTrue() {
        viewModel.search(with: "", important: true)
        XCTAssert(viewMock.arrayData.count == 2, "testSearch_TextIsEmptyAndFlagTrue_ReturnElementCountIsTwo")
    }
    
    func testSearchTextIsAAndFlagTrue() {
        viewModel.search(with: "a", important: true)
        XCTAssert(viewMock.arrayData.count == 1, "testSearch_TextIsAAndFlagTrue_ReturnElementCountIsOne")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

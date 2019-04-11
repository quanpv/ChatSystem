//
//  CSObservableTests.swift
//  ChatSystemTests
//
//  Created by bit on 4/11/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import XCTest
@testable import ChatSystem_DEV

class CSObservableTests: XCTestCase {
    var mock: String!
    var observable: Observable<String>!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mock = "abcdef"
        observable = Observable("abcdef")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mock = nil
        observable = nil
    }

    func testObserve() {
        observable.observe(observer: self) { [weak self] (newValue) in
            XCTAssertEqual(newValue, self?.mock)
        }
        let addition = "aaaa"
        mock += addition
        observable.value += addition
    }

}

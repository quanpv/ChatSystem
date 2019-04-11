//
//  CSThreadSafeTests.swift
//  ChatSystemTests
//
//  Created by bit on 4/11/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import XCTest
@testable import ChatSystem_DEV

class CSThreadSafeTests: XCTestCase {
    
    var synchronizedArray: SynchronizedArray<String>!
    var arrayMock: Array<String>!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        arrayMock = ["a", "b", "c", "d", "e", "b", "c"]
        synchronizedArray = SynchronizedArray.init(["a", "b", "c", "d", "e", "b", "c"])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        arrayMock = nil
        synchronizedArray = nil
    }
    
    private func assertEqual(_ arrayMock: Array<String>, _ synchronizedArray: SynchronizedArray<String>) {
        for i in 0..<arrayMock.count {
            XCTAssertEqual(arrayMock[i], synchronizedArray[i])
        }
    }

    func testFirst() {
        XCTAssertEqual(arrayMock.first, synchronizedArray.first)
    }
    
    func testLast() {
        XCTAssertEqual(arrayMock.last, synchronizedArray.last)
    }
    
    func testCount() {
        XCTAssertEqual(arrayMock.count, synchronizedArray.count)
    }
    
    func testEmpty() {
        XCTAssertEqual(arrayMock.isEmpty, synchronizedArray.isEmpty)
        
        arrayMock = []
        synchronizedArray = SynchronizedArray()
        XCTAssertEqual(arrayMock.isEmpty, synchronizedArray.isEmpty)
    }
    
    func testDescription() {
        XCTAssertEqual(arrayMock.description, synchronizedArray.description)
    }

    func testFirstWherePredicate() {
        XCTAssertEqual(arrayMock.first(where: {$0 == "b"}), synchronizedArray.first(where: {$0 == "b"}))
    }
    
    func testLastWherePridicate() {
        XCTAssertEqual(arrayMock.last(where: {$0 == "b"}), synchronizedArray.last(where: {$0 == "b"}))
    }
    
    func testSubscript() {
        arrayMock[0] = "w"
        synchronizedArray[0] = "w"
        XCTAssertEqual(arrayMock[0], synchronizedArray[0])
    }
    
    func testFilter() {
        let mock = arrayMock.filter({$0 == "b"})
        let synchronized = synchronizedArray.filter({$0 == "b"})
        for i in 0..<mock.count {
            XCTAssertEqual(mock[i], synchronized[i])
        }
    }
    
    func testIndexWherePredicate() {
        XCTAssertEqual(synchronizedArray.index(where: {$0 == "c"}), arrayMock.index(where: {$0 == "c"}))
    }
    
    func testSorted() {
        let mock = arrayMock.sorted(by: {$0 < $1})
        let synchronized = synchronizedArray.sorted(by: {$0 < $1})
        assertEqual(mock, synchronized)
    }
    
    func testMap() {
        let mock = arrayMock.map({$0 + "1"})
        let synchronized = synchronizedArray.map({$0 + "1"})
        XCTAssertEqual(mock, synchronized)
    }
    
    func testCompactMap() {
        let mock = arrayMock.compactMap({$0 + "1"})
        let synchronized = synchronizedArray.compactMap({$0 + "1"})
        XCTAssertEqual(mock, synchronized)
    }
    
    func testReduceInit() {
        let mock = arrayMock.reduce("Result", {$0 + $1})
        let synchronized = synchronizedArray.reduce("Result", {$0 + $1})
        XCTAssertEqual(mock, synchronized)
    }
    
    func testReduceInto() {
        let mock = arrayMock.reduce(into: [:]) { counts, element in
            counts[element, default: 0] += 1
        }
        let synchronized = synchronizedArray.reduce(into: [:]) { counts, element in
            counts[element, default: 0] += 1
        }
        XCTAssertEqual(mock, synchronized)
    }
    
    func testForEach() {
        var mock = ""
        arrayMock.forEach { (a) in
            mock += a
        }
        var synchronized = ""
        synchronizedArray.forEach { (a) in
            synchronized += a
        }
        XCTAssertEqual(mock, synchronized)
    }
    
    func testContainsWherePridicate() {
        XCTAssertEqual(arrayMock.contains(where: {$0 == "c"}), synchronizedArray.contains(where: {$0 == "c"}))
    }
    
    func testAllSatisfy() {
        XCTAssertEqual(arrayMock.allSatisfy({$0.hasPrefix("c")}), synchronizedArray.allSatisfy({$0.hasPrefix("c")}))
    }
    
    func testAppendElement() {
        arrayMock.append("T##newElement: String##String")
        synchronizedArray.append("T##newElement: String##String")
        assertEqual(arrayMock, synchronizedArray)
    }
    
    func testAppendArrayElement() {
        arrayMock.append(contentsOf: ["Sequence"])
        synchronizedArray.append(["Sequence"])
        assertEqual(arrayMock, synchronizedArray)
    }
    
    func testInsert() {
        arrayMock.insert("T##newElement: String##String", at: 0)
        synchronizedArray.insert("T##newElement: String##String", at: 0)
        assertEqual(arrayMock, synchronizedArray)
    }
    
    func testRemove() {
        arrayMock.remove(at: 0)
        synchronizedArray.remove(at: 0)
        assertEqual(arrayMock, synchronizedArray)
    }
    
    func testRemoveWherePredicate() {
        synchronizedArray.remove(where: {$0 == "b"})
        while let index = arrayMock.index(of: "b") {
            arrayMock.remove(at: index)
        }
        assertEqual(arrayMock, synchronizedArray)
    }
    
    func testRemoveAll() {
        arrayMock.removeAll()
        synchronizedArray.removeAll()
        assertEqual(arrayMock, synchronizedArray)
    }
    
    func testCopy() {
        let synchronized = synchronizedArray.copy()
        var addressSynchronized = ""
        withUnsafePointer(to: synchronized, { addressSynchronized = "\($0)" })
        var addressSynchronizedArray = ""
        withUnsafePointer(to: synchronizedArray, { addressSynchronizedArray = "\($0)" })
        XCTAssertNotEqual(addressSynchronized, addressSynchronizedArray)
        assertEqual(arrayMock, synchronized)
    }
    
    func testContains() {
        XCTAssertEqual(arrayMock.contains("e"), synchronizedArray.contains("e"))
    }
    
    func testAddElementEnd() {
        arrayMock.append("asdf")
        synchronizedArray += "asdf"
        assertEqual(arrayMock, synchronizedArray)
    }
    
    func testAddArrayEnd() {
        arrayMock += ["asdf", "adsfasdfadsf"]
        synchronizedArray += ["asdf", "adsfasdfadsf"]
        assertEqual(arrayMock, synchronizedArray)
    }
}

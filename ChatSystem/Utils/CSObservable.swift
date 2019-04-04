//
//  CSObservable.swift
//  ChatSystem
//
//  Created by bit on 4/2/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import Foundation

public class Observable<T> {
    public typealias Handler = ((T) -> Void)
    
    var value: T {
        didSet {
            self.notify()
        }
    }
    
    fileprivate var observers = [String: Handler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    fileprivate func addObserver(_ observer: NSObject, handler: @escaping Handler) {
        observers[observer.description] = handler
    }
    
    public func observe(observer: NSObject, handler: @escaping Handler) {
        addObserver(observer, handler: handler)
        notify()
    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    deinit {
        observers.removeAll()
    }
}


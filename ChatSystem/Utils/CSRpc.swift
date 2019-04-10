//
//  CSRpc.swift
//  ChatSystem
//
//  Created by bit on 4/9/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit
import Queuer
import SwiftProtobuf

class CSRpc: NSObject {
    let queue = Queuer(name: "rpc.queue", maxConcurrentOperationCount: 1, qualityOfService: .default)
    func start() {
        if CSSKConnection.shared.status == .opening || CSSKConnection.shared.status == .open {
            return
        } else if CSSKConnection.shared.status == .closing {
            let semaphore = Semaphore()
            while CSSKConnection.shared.status == .closing {
                semaphore.wait(.now() + 0.1)
            }
            semaphore.continue()
        }
        let semaphore = Semaphore()
        while CSSKConnection.shared.status != .open {
            let operationConnect = SynchronousOperation(name: "rpc.connect.socket") { (concurrentOperation) in
                CSSKConnection.shared.openSocket(completion: { (status) in
                    if status == .open {
                        semaphore.continue()
                    }
                })
            }
            queue.addOperation(operationConnect)
            semaphore.wait(.now() + 0.1)
        }
    }
    
    func stop() {
        CSSKConnection.shared.closeSocket()
    }
    
    private func send(message:Message, service: String) {
        // TODO: Check and handle status connection before send
        CSSKConnection.shared.write(message: message)
    }
    
    private func read<M: Message>(messageType: M.Type) -> M? {
        // TODO: check and handle status connection before read
        return CSSKConnection.shared.read(messageType: messageType)
    }
    
    func testGetContact(contact: Contact, completed:@escaping ()->Void) {
        let testGetContact = ConcurrentOperation { [weak self] _ in
            self?.send(message: contact, service: "T##String")
        }
        queue.addOperation(testGetContact)
        queue.addCompletionHandler { [weak self] in
            track(self?.read(messageType: Contact.self) as Any)
            completed()
        }
    }
}

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
    let APP_ID_BITS: Int = 8
    let SEQUENCE_BITS: Int = 14
    //static long TIMESTAMP_BITS = 41;
    let APP_ID_MASK: Int = 255 // (1L << APP_ID_BITS) - 1L;
    let SEQUENCE_MASK: Int = 16383 //(1L << SEQUENCE_BITS) - 1L;
    let TIMESTAMP_MASK: Int =  2199023255551//(1L << TIMESTAMP_BITS) - 1L;
    let TIMESTAMP_OFFSET: Int = 1388505600000
    var serial: Int = 0
    
    
    let queue = Queuer(name: "rpc.queue", maxConcurrentOperationCount: 1, qualityOfService: .default)
    let concurrentQueue = Queuer(name: "rpc.conrurrentQueue", maxConcurrentOperationCount: OperationQueue.defaultMaxConcurrentOperationCount, qualityOfService: .background)
    
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
    
    private func add(request: RpcMessage, completion: @escaping ((RpcMessage) -> Void)) {
        self.send(message: request, service: "String")
        let semaphore = Semaphore()
        while true {
            if CSSKConnection.shared.inputStream.streamStatus == .open && CSSKConnection.shared.inputStream.hasBytesAvailable == true {
                if let msg = read(messageType: RpcMessage.self) {
                    completion(msg)
                    semaphore.continue()
                    break
                } else {
                    semaphore.wait(.now() + 0.5)
                }
            }
        }
        semaphore.wait(.now() + UIApplication.connectionTimeOut)
        semaphore.continue()
    }
    
    private func rpc(message: Message) -> RpcMessage {
        var rpcMessage = RpcMessage.init()
        rpcMessage.id = Int64(nextSerial())
        rpcMessage.version = "1.0.0"
        rpcMessage.service = "account"
        rpcMessage.payloadData = try! message.serializedData()
        rpcMessage.payloadClass = "LoginRequest"
        return rpcMessage
    }
    
    private func nextSerial() -> Int {
        serial += 1
        let seq = serial &+ SEQUENCE_MASK
        let now = (((Int)(CFAbsoluteTimeGetCurrent() * 1000)) - TIMESTAMP_OFFSET) &+ TIMESTAMP_MASK
        return (now << (SEQUENCE_BITS + APP_ID_BITS)) | (Int)(seq << APP_ID_BITS) | (Int)(0 &+ APP_ID_MASK)
    }
    
    func rpcLogin(request: LoginRequest, completion: @escaping ((RpcMessage.Result, LoginResponse) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            let rpcMessage = self.rpc(message: request)
            self.add(request: rpcMessage, completion: { (message) in
                DispatchQueue.main.async {
                    let _ = message
                    //                    completion(message.result, msg)
                }
            })
        }
    }
    
}

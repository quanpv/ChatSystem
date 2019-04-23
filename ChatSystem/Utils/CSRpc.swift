//
//  CSRpc.swift
//  ChatSystem
//
//  Created by bit on 4/9/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit
import SwiftProtobuf

extension CSRpc: MessageReceivedDelegate {
    func receivedMessage() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            if CSSKConnection.shared.outputStream.streamStatus != .open {
                self?.openConnection()
            }
            guard let rpcMessage = CSSKConnection.shared.read(messageType: RpcMessage.self) else { return }
            guard let completion = self?.rpcRequestQueue[rpcMessage.id] else { return }
            completion(rpcMessage.result, rpcMessage)
            self?.rpcRequestQueue[rpcMessage.id] = nil
        }
    }
}

class CSRpc: NSObject {
    
    // Singleton
    static let shared = CSRpc()
    private override init() { }
    
    let APP_ID_BITS: Int = 8
    let SEQUENCE_BITS: Int = 14
    //static long TIMESTAMP_BITS = 41;
    let APP_ID_MASK: Int = 255 // (1L << APP_ID_BITS) - 1L;
    let SEQUENCE_MASK: Int = 16383 //(1L << SEQUENCE_BITS) - 1L;
    let TIMESTAMP_MASK: Int =  2199023255551//(1L << TIMESTAMP_BITS) - 1L;
    let TIMESTAMP_OFFSET: Int = 1388505600000
    var serial: Int = 0
    
    private var rpcRequestQueue = [Int64: ((RpcMessage.Result, RpcMessage) -> Void)]()
    private let serialQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).rpcSerialQueue")
    
    func start() {
        if CSSKConnection.shared.isOpen() {
            return
        }
        DispatchQueue.global(qos: .default).async {
            self.openConnection()
        }
        CSSKConnection.shared.receivedDelegate = self
    }
    
    func stop() {
        CSSKConnection.shared.closeSocket()
    }
    
    private func openConnection() {
        let semaphore = DispatchSemaphore(value: 0)
        let timeout = DispatchTime.now() + UIApplication.connectionTimeOut
        while !CSSKConnection.shared.isOpen() {
            if Int(timeout.uptimeNanoseconds) - Int(DispatchTime.now().uptimeNanoseconds) < 0 {
                // TODO: Handle timeout open connect
                let alert = UIAlertController(title: "", message: "Request time out", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                break
            }
            CSSKConnection.shared.openSocket(completion: { (status) in
                if status == .open {
                    semaphore.signal()
                }
                _ = semaphore.wait(timeout: .now() + 0.1)
            })
        }
    }
    
    private func add(request: Message, completion: @escaping ((RpcMessage.Result, RpcMessage) -> Void)) {
        if CSSKConnection.shared.outputStream.streamStatus != .open {
            openConnection()
        }
        trackRequest(request)
        let rpcMessage = self.rpc(message: request)
        CSSKConnection.shared.write(message: rpcMessage)
        rpcRequestQueue[rpcMessage.id] = completion
    }
    
    private func rpc(message: Message) -> RpcMessage {
        var rpcMessage = RpcMessage.init()
        rpcMessage.id = Int64(nextSerial())
        rpcMessage.version = "1.0.0"
        rpcMessage.service = "account"
        rpcMessage.payloadData = try! message.serializedData()
        rpcMessage.payloadClass = String(describing: type(of: message))
        return rpcMessage
    }
    
    private func nextSerial() -> Int {
        serial += 1
        let seq = serial &+ SEQUENCE_MASK
        let now = (((Int)(CFAbsoluteTimeGetCurrent() * 1000)) - TIMESTAMP_OFFSET) &+ TIMESTAMP_MASK
        return (now << (SEQUENCE_BITS + APP_ID_BITS)) | (Int)(seq << APP_ID_BITS) | (Int)(0 &+ APP_ID_MASK)
    }
    
}

// MARK: - Request
extension CSRpc {
    
    func login(with request: LoginRequest, completion: @escaping ((RpcMessage.Result, LoginResponse?) -> Void)) {
        serialQueue.async {
            self.add(request: request, completion: { (result, rpcMessage) in
                let response = try? LoginResponse(serializedData: rpcMessage.payloadData)
                trackResponse(response as Any)
                DispatchQueue.main.async {
                    completion(result, response)
                }
            })
        }
    }
}

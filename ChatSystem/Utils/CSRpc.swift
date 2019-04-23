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
    
    /// Event when received message
    func receivedMessage() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            if !CSSKConnection.shared.isOpen() {
                self?.openConnection()
            }
            if CSSKConnection.shared.inputStream.hasBytesAvailable {
                guard let rpcMessage = CSSKConnection.shared.read(messageType: RpcMessage.self) else { return }
                guard rpcMessage.id > 0 else { return }
                guard let completion = self?.rpcRequestQueue[rpcMessage.id] else { return }
                completion(rpcMessage)
                self?.rpcRequestQueue[rpcMessage.id] = nil
            }
        }
    }
}

class CSRpc: NSObject {
    
    /// Singleton
    static let shared = CSRpc()
    private override init() { }
    
    /// Serial for canculate id request
    private var serial: Int = 0
    
    /// Dictionary store completion response for request
    private var rpcRequestQueue = [Int64: ((RpcMessage) -> Void)]()
    
    /// Serial queue FIFO
    private let serialQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).rpcSerialQueue")
    
    // MARK: - Public function
    
    /// Start connect socket
    func start() {
        if CSSKConnection.shared.isOpen() {
            return
        }
        DispatchQueue.global(qos: .default).async {
            self.openConnection()
            CSSKConnection.shared.receivedDelegate = self
        }
        DispatchQueue.global(qos: .default).async {
            let semaphoreConnect = DispatchSemaphore(value: 0)
            let timeout = DispatchTime.now() + UIApplication.connectionTimeOut
            while !CSSKConnection.shared.isOpen() {
                if Int(timeout.uptimeNanoseconds) - Int(DispatchTime.now().uptimeNanoseconds) < 0 {
                    self.handleTimeOut()
                    semaphoreConnect.signal()
                    return
                }
                _ = semaphoreConnect.wait(timeout: .now() + 0.25)
            }
            semaphoreConnect.signal()
            
            let semaphore = DispatchSemaphore(value: 0)
            while CSSKConnection.shared.isOpen() {
                self.add(request: HeartbeatMessage(), service: heartbeatService, completion: { _ in })
                _ = semaphore.wait(timeout: .now() + UIApplication.heartBeatInterval)
            }
            semaphore.signal()
        }
    }
    
    /// Stop: connect socket
    func stop() {
        CSSKConnection.shared.closeSocket()
    }
    
    /// Cancell all task
    func cancelAll() {
        serialQueue.suspend()
        rpcRequestQueue.removeAll()
    }
    
    /// Suspends the invocation of block objects on a dispatch object.
    func suspend() {
        serialQueue.suspend()
    }
    
    /// Resume the invocation of block objects on a dispatch object.
    func resume() {
        if rpcRequestQueue.count > 0 {
            serialQueue.resume()
        }
    }
    
    // MARK: - Private function
    
    /// Open connection socket
    private func openConnection() {
        let semaphore = DispatchSemaphore(value: 0)
        let timeout = DispatchTime.now() + UIApplication.connectionTimeOut
        while !CSSKConnection.shared.isOpen() {
            if Int(timeout.uptimeNanoseconds) - Int(DispatchTime.now().uptimeNanoseconds) < 0 {
                handleTimeOut()
                semaphore.signal()
                return
            }
            CSSKConnection.shared.openSocket(completion: { (status) in
                if status == .open {
                    semaphore.signal()
                }
                _ = semaphore.wait(timeout: .now() + 0.1)
            })
        }
        semaphore.signal()
    }
    
    /// Write message to output stream
    ///
    /// - Parameters:
    ///   - request: Message
    ///   - service: string define in config
    ///   - completion: block response RpcMessage
    private func add(request: Message, service: String, completion: @escaping ((RpcMessage) -> Void)) {
        let rpcMessage = self.rpc(message: request, service: service)
        trackRequest(rpcMessage.id, request)
        
        if CSSKConnection.shared.outputStream.streamStatus != .open {
            openConnection()
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let timeout = DispatchTime.now() + UIApplication.connectionTimeOut
        while !CSSKConnection.shared.outputStream.hasSpaceAvailable {
            if Int(timeout.uptimeNanoseconds) - Int(DispatchTime.now().uptimeNanoseconds) < 0 {
                handleTimeOut()
                semaphore.signal()
                return
            }
            _ = semaphore.wait(timeout: .now() + 0.1)
        }
        semaphore.signal()
        
        CSSKConnection.shared.write(message: rpcMessage)
        rpcRequestQueue[rpcMessage.id] = completion
    }
    
    /// Get RpcMessage from Message
    ///
    /// - Parameters:
    ///   - message: Message
    ///   - service: String
    /// - Returns: RpcMessage
    private func rpc(message: Message, service: String) -> RpcMessage {
        var rpcMessage = RpcMessage.init()
        rpcMessage.id = Int64(nextSerial())
        rpcMessage.version = "1.0.0"
        rpcMessage.service = service
        rpcMessage.payloadData = try! message.serializedData()
        rpcMessage.payloadClass = String(describing: type(of: message))
        return rpcMessage
    }
    
    /// Generate id request
    ///
    /// - Returns: Int
    private func nextSerial() -> Int {
        serial += 1
        let seq = serial &+ SEQUENCE_MASK
        let now = (((Int)(CFAbsoluteTimeGetCurrent() * 1000)) - TIMESTAMP_OFFSET) &+ TIMESTAMP_MASK
        return (now << (SEQUENCE_BITS + APP_ID_BITS)) | (Int)(seq << APP_ID_BITS) | (Int)(0 &+ APP_ID_MASK)
    }
    
    /// Handle timeout event
    private func handleTimeOut() {
        DispatchQueue.main.async {
            guard let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                fatalError("rootViewController not is navigation controller")
            }
            guard let topVC = nav.topViewController, !(topVC.isKind(of: UIAlertController.self)) else {
                return
            }
            let alert = UIAlertController(title: "", message: "Request time out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            if topVC.presentedViewController == nil {
                topVC.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - Request
extension CSRpc {
    
    /// Login
    ///
    /// - Parameters:
    ///   - request: LoginRequest
    ///   - completion: Block: RpcMessage.Result, LoginResponse?
    func login(with request: LoginRequest, completion: @escaping ((RpcMessage.Result, LoginResponse?) -> Void)) {
        serialQueue.async {
            self.add(request: request, service: accountService, completion: { (rpcMessage) in
                let response = try? LoginResponse(serializedData: rpcMessage.payloadData)
                trackResponse(rpcMessage.id, response as Any)
                DispatchQueue.main.async {
                    completion(rpcMessage.result, response)
                }
            })
        }
    }
}

//
//  CSSKConnection.swift
//  ChatSystem
//
//  Created by bit on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol MessageDelegate: class {
    func receivedMessage(message: MessageModel)
}

enum CSSKConnectionStatus {
    case notOpen, open, opening, close, closed, error
}

class CSSKConnection: NSObject {
    
    weak var delegate: MessageDelegate?
    
    public var status: CSSKConnectionStatus = .notOpen
    public lazy var isOpening: Bool = {
        return inputStream.streamStatus == Stream.Status.open && outputStream.streamStatus ==  Stream.Status.open
    }()
    
    let maxReadLength = 1024
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    var username = ""
    
    static let shared = CSSKConnection()
    
    private override init() { }
    
    public func openSocket(completion:((_ status: CSSKConnectionStatus) -> Void)?) {
//        if status == .opening {
//            return
//        }
        
        status = .open
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           UIApplication.socketHost as CFString,
                                           UIApplication.socketPort,
                                           &readStream,
                                           &writeStream)
        
//        let sslSettings = [kCFStreamSSLValidatesCertificateChain:kCFBooleanTrue,
//                           kCFStreamSSLPeerName:UIApplication.sslPeerName,
//                           Stream.PropertyKey.socketSecurityLevelKey:StreamSocketSecurityLevel.negotiatedSSL] as [AnyHashable : Any]
//        
//        inputStream.setValue(sslSettings, forKey: kCFStreamPropertySSLSettings as String)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: .common)
        outputStream.schedule(in: .main, forMode: .common)
        
        inputStream.open()
        outputStream.open()
        
        if waitOpenSocket() {
            status = .opening
        } else {
            status = .closed
        }
        completion?(status)
    }
    
    public func closeSocket() {
        status = .close
        
        if inputStream != nil {
            inputStream.close()
            inputStream.remove(from: .main, forMode: .common)
        }
        
        if outputStream != nil {
            outputStream.close()
            outputStream.remove(from: .main, forMode: .common)
        }
        
        status = .closed
    }
    
    private func waitOpenSocket() -> Bool {
        var readStreamStatus = false
        var writeStreamStatus = false
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            readStreamStatus = self.waitOpenStream(stream: self.inputStream)
            group.leave()
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            writeStreamStatus = self.waitOpenStream(stream: self.outputStream)
            group.leave()
        }
        
        let timeOut = DispatchTime.now() + UIApplication.connectionTimeOut
        let _ = group.wait(timeout: timeOut)
        
        return readStreamStatus == true && writeStreamStatus == true
    }
    
    private func waitOpenStream(stream: Stream) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        
        while (true) {
            let status = stream.streamStatus
            if status == Stream.Status.opening {
                break
            } else if (status != Stream.Status.opening) {
                return false
            }
            
            let timeout = DispatchTime.now() + 0.25
            let _ = semaphore.wait(timeout: timeout)
        }
        
        return true
    }
    
    func joinChat(username: String) {
        let data = "iam:\(username)".data(using: .utf8)!
        self.username = username
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    func sendMessage(message: String) {
        let data = "msg:\(message)".data(using: .utf8)!
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
}

extension CSSKConnection: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            track("open completed")
        case Stream.Event.hasBytesAvailable:
            track("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            track("close socket")
            closeSocket()
        case Stream.Event.errorOccurred:
            track("error occurred")
        case Stream.Event.hasSpaceAvailable:
            track("has space available")
        default:
            track("some other event...")
            break
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            if numberOfBytesRead < 0 {
                if let _ = inputStream.streamError {
                    break
                }
            }
            
            if let message = processedData(buffer: buffer, length: numberOfBytesRead) {
                delegate?.receivedMessage(message: message)
            }
        }
    }
    
    private func processedData(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> MessageModel? {
        guard let stringArray = String(bytesNoCopy: buffer,
                                       length: length,
                                       encoding: .ascii,
                                       freeWhenDone: true)?.components(separatedBy: ":"),
            let name = stringArray.first,
            let message = stringArray.last else {
                return nil
        }
        
        let messageSender:MessageSender = (name == self.username) ? .ourself : .someoneElse
        
        return MessageModel(message: message, messageSender: messageSender, username: name, time: Formatter.shared.dateFormat.string(from: Date()))
    }
}

//
//  CSSKConnection.swift
//  ChatSystem
//
//  Created by bit on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit

protocol MessageDelegate: class {
    func receivedMessage(message: Any)
}

enum SCSKConnectionStatus {
    case notOpen, open, opening, close, closed, error
}

class CSSKConnection: NSObject {
    
    weak var delegate: MessageDelegate?
    
    public var status: SCSKConnectionStatus = .notOpen
    public lazy var isOpening: Bool = {
        return inputStream.streamStatus == Stream.Status.open && outputStream.streamStatus ==  Stream.Status.open
    }()
    
    let maxReadLength = 1024
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    static let shared = CSSKConnection()
    
    public func openSocket() {
        status = .open
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           UIApplication.socketHost as CFString,
                                           UIApplication.socketPort,
                                           &readStream,
                                           &writeStream)
        
        let sslSettings = [kCFStreamSSLValidatesCertificateChain:kCFBooleanTrue,
                           kCFStreamSSLPeerName:UIApplication.sslPeerName,
                           Stream.PropertyKey.socketSecurityLevelKey:StreamSocketSecurityLevel.negotiatedSSL] as [AnyHashable : Any]
        
        inputStream.setValue(sslSettings, forKey: kCFStreamPropertySSLSettings as String)
        
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
    }
    
    public func closeSocket() {
        status = .close
        
        inputStream.close()
        inputStream.remove(from: .main, forMode: .common)
        
        outputStream.close()
        outputStream.remove(from: .main, forMode: .common)
        
        status = .closed
    }
    
    private func waitOpenSocket() -> Bool {
        var readStreamStatus = false
        var writeStreamStatus = false
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async(group: group) { [unowned self] in
            readStreamStatus = self.waitOpenStream(stream: self.inputStream)
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async(group: group) { [unowned self] in
            writeStreamStatus = self.waitOpenStream(stream: self.outputStream)
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
}

extension CSSKConnection: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            print("opem completed")
        case Stream.Event.hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            closeSocket()
        case Stream.Event.errorOccurred:
            print("error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
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
    
    private func processedData(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> String? {
        let message = String(cString: buffer)
        
        return message
    }
}

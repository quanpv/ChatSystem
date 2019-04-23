//
//  CSSKConnection.swift
//  ChatSystem
//
//  Created by bit on 3/26/19.
//  Copyright © 2019 Pham Van Quan. All rights reserved.
//

import UIKit
import SwiftProtobuf

@available(*, deprecated, message: "Not using for implement")
protocol MessageDelegate: class {
    func receivedMessage(message: MessageModel)
}

/// Event when received Message
protocol MessageReceivedDelegate: class {
    func receivedMessage()
}

/// Status of socket connection
///
/// - notOpen: is not open
/// - opening: is opening
/// - open: is open
/// - closing: is closing
/// - close: is close
/// - error: is error
enum CSSKConnectionStatus {
    case notOpen, opening, open, closing, close, error
}

/// Class singleton connection socket
class CSSKConnection: NSObject {
    
    @available(*, deprecated, message: "Not using for implement")
    weak var delegate: MessageDelegate?
    
    /// Delegate received message
    weak var receivedDelegate: MessageReceivedDelegate?
    
    /// Status of connection
    private var status: CSSKConnectionStatus = .notOpen
    
    /// max length per message
    private let maxReadLength = 1024
    
    /// input stream for read message
    var inputStream: InputStream!
    
    /// output stream for write message
    var outputStream: OutputStream!
    
    @available(*, deprecated, message: "Not using for implement")
    var username = ""
    
    /// Singleton class define
    static let shared = CSSKConnection()
    private override init() { }
    
    /// Open socket
    ///
    /// - Parameter completion: Block: CSSKConnectionStatus
    public func openSocket(completion:((_ status: CSSKConnectionStatus) -> Void)?) {
        if status == .open || status == .opening || status == .closing {
            completion?(status)
            return
        }
        
        status = .opening
        
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
            status = .open
        } else {
            status = .close
        }
        completion?(status)
    }
    
    /// Close socket
    public func closeSocket() {
        status = .closing
        
        inputStream?.close()
        inputStream?.remove(from: .main, forMode: .common)
        
        outputStream?.close()
        outputStream?.remove(from: .main, forMode: .common)
        
        status = .close
    }
    
    /// Check inputStream and outputStream is open
    ///
    /// - Returns: Bool
    public func isOpen() -> Bool {
        return inputStream?.streamStatus == .open && outputStream?.streamStatus ==  .open
    }
    
    /// Wait for open socket
    ///
    /// - Returns: Bool
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
    
    /// Wait for open stream
    ///
    /// - Parameter stream: inputStream or outputStream
    /// - Returns: Bool
    private func waitOpenStream(stream: Stream) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        
        while (true) {
            let status = stream.streamStatus
            if status == Stream.Status.open {
                break
            } else if (status != Stream.Status.opening) {
                return false
            }
            
            let timeout = DispatchTime.now() + 0.25
            let _ = semaphore.wait(timeout: timeout)
        }
        
        return true
    }
    
    @available(*, deprecated, message: "Not using for implement")
    func joinChat(username: String) {
        let data = "iam:\(username)".data(using: .utf8)!
        self.username = username
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    @available(*, deprecated, message: "Not using for implement")
    func sendMessage(message: String) {
        let data = "msg:\(message)".data(using: .utf8)!
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    /// Write message to outputStream
    ///
    /// - Parameter message: Message
    func write(message: Message) {
        do {
            try BinaryDelimited.serialize(message: message, to: outputStream)
        } catch BinaryDelimited.Error.truncated {
            track("Error: While reading/writing to the stream, less than the expected bytes was read/written")
        } catch BinaryDelimited.Error.unknownStreamError {
            track("Error: Unknown")
        } catch BinaryDecodingError.missingRequiredFields {
            track("Error: Missing required fields")
        } catch let error {
            track("Error: \(error.localizedDescription)")
        }
    }
    
    /// Read message from inputStream
    ///
    /// - Parameter messageType: Message.Type
    /// - Returns: Message?
    func read<M: Message>(messageType: M.Type) -> M? {
        do {
            return try BinaryDelimited.parse(messageType: messageType, from: inputStream)
        } catch BinaryDelimited.Error.truncated {
            track("Error: While reading/writing to the stream, less than the expected bytes was read/written")
            return nil
        } catch BinaryDelimited.Error.unknownStreamError {
            track("Error: Unknown")
            return nil
        } catch BinaryDecodingError.missingRequiredFields {
            track("Error: Missing required fields")
            return nil
        } catch let error {
            track("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
}

// MARK: - StreamDelegate
extension CSSKConnection: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            break
        case Stream.Event.hasBytesAvailable:
            receivedDelegate?.receivedMessage()
        case Stream.Event.endEncountered:
            track("close socket")
        case Stream.Event.errorOccurred:
            track("error occurred")
        case Stream.Event.hasSpaceAvailable:
            break
        default:
            track("some other event...")
            break
        }
    }
}

//
//  ClientConnection.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 05/02/22.
//

import Foundation
import Network


@available(macOS 10.14, *)
class ClientConnection {

    var nwConnection: NWConnection
    let DATAGRAM_SIZE: Int = 1460
    
    public var type: String = ""
    var image: Data = Data()
    
    init(){
        let h = NWEndpoint.Host("0.0.0.0")
        let p = NWEndpoint.Port("0")!
        let connectionParams = NWParameters.udp
        self.nwConnection = NWConnection(host: h, port: p, using: connectionParams)
    }

    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
    }

    var didStopCallback: ((Error?) -> Void)? = nil

    func start() {
        self.nwConnection.stateUpdateHandler = stateDidChange(to:)
        self.nwConnection.start(queue: .global())
    }
    
    func isReady() -> Bool {
        return self.nwConnection.state == NWConnection.State.ready
    }
    
    func isCancelled() -> Bool {
        return self.nwConnection.state == NWConnection.State.cancelled
    }
    
    private func stateDidChange(to state: NWConnection.State) {
        switch state {
            case .setup:
                NSLog("Client connection setup")
            case .waiting( _):
                NSLog("Client connection waiting")
            case .preparing:
                NSLog("Client connection preparing")
            case .ready:
                NSLog("Client connection ready")
            case .cancelled:
                NSLog("Client connection cancelled")
                cancel(error: nil)
            case .failed(let error):
                NSLog("Client connection failed")
                connectionDidFail(error: error)
            default:
                break
        }
    }
    
    public func resetImage()->Void {
        self.image = Data()
    }
    
    func send(request: Data)->Data {
        let send_semaphone: DispatchSemaphore = DispatchSemaphore(value: 0)
        self.nwConnection.send(content: request, completion: .contentProcessed( { error in
            if let error = error {
                NSLog("send connection error")
                self.connectionDidFail(error: error)
                return
            }
            send_semaphone.signal()
        }))
        _ = send_semaphone.wait(timeout: DispatchTime.distantFuture)
        
        var response: Data = Data()
        let receive_semaphone: DispatchSemaphore = DispatchSemaphore(value: 0)
        self.nwConnection.receive(minimumIncompleteLength: 16, maximumLength: 32, completion: { (data, _, isComplete, error) in
            if isComplete {
                if let data = data, !data.isEmpty {
                    response.append(data)
                }
            } else if let error = error {
                NSLog("setupReceive connection error \(error)")
            } else {
                NSLog("setupReceive inComplete \(String(decoding: data!, as: UTF8.self))")
            }
            receive_semaphone.signal()
        })
        _ = receive_semaphone.wait(timeout: .now() + DispatchTimeInterval.seconds(5))
        return response
    }
    
    func receiveImage(size: Int)->Data {
        var response = self.receiveAll(size: size)
        while (self.image.count < size && response > 0 ){
            response = self.receiveAll(size: size)
        }
        NSLog("receiveImage data: \(self.image.count)")
        return self.image
    }
    
    func receiveAll(size: Int)->Int {
        var byte_count: Int = 0
        let receiveAll_semaphone: DispatchSemaphore = DispatchSemaphore(value: 0)
        self.nwConnection.receive(minimumIncompleteLength: size, maximumLength: size, completion: { (data, _, isComplete, error) in
            if isComplete {
                if let data = data, !data.isEmpty {
                    byte_count = data.count
                    self.image.append(data)
                }
            } else if let error = error {
                NSLog("setupReceiveAll connection error \(error)")
            } else {
                NSLog("setupReceiveAll inComplete \(self.image.count)")
            }
            _ = receiveAll_semaphone.signal()
        })
        _ = receiveAll_semaphone.wait(timeout: .now() + DispatchTimeInterval.seconds(1))
        return byte_count
    }
    
    private func connectionDidFail(error: Error) {
        NSLog("connection did fail, error: \(error)")
        cancel(error: error)
    }

    private func connectionDidEnd() {
        NSLog("connection did end")
        cancel(error: nil)
    }

    public func cancel(error: Error?) {
        self.nwConnection.stateUpdateHandler = nil
        //self.nwConnection.cancel()
        self.nwConnection.forceCancel()
        //self.nwConnection.cancelCurrentEndpoint()
        while(self.nwConnection.state != NWConnection.State.cancelled){
            sleep(1)
            NSLog("waiting for connection to be cancelled")
        }
        NSLog("XXXXXX  Connection Ends XXXXX")
    }
}


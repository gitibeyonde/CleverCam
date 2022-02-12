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

    let nwConnection: NWConnection
    let queue: DispatchQueue = DispatchQueue(label: "CamQ")
    let datagram_size: Int = 1460
    
    public var type: String = ""
    public var min_size: Int = 10
    public var max_size: Int = 32
    var image: Data = Data()

    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
    }

    var didStopCallback: ((Error?) -> Void)? = nil

    func start() {
        nwConnection.stateUpdateHandler = stateDidChange(to:)
        nwConnection.start(queue: queue)
    }
    
    func isReady() -> Bool {
        return nwConnection.state == NWConnection.State.ready
    }
    
    func isCancelled() -> Bool {
        return nwConnection.state == NWConnection.State.cancelled
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
        nwConnection.send(content: request, completion: .contentProcessed( { error in
            if let error = error {
                NSLog("send connection error")
                self.connectionDidFail(error: error)
                return
            }
            send_semaphone.signal()
        }))
        _ = send_semaphone.wait(timeout: .now() + DispatchTimeInterval.seconds(2))
        
        var response: Data = Data()
        let receive_semaphone: DispatchSemaphore = DispatchSemaphore(value: 0)
        nwConnection.receiveMessage(completion: { (data, _, isComplete, error) in
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
        _ = receive_semaphone.wait(timeout: .now() + DispatchTimeInterval.seconds(2))
        return response
    }
    
    func receiveImage(size: Int)->Data {
        //let max_loop: Int = Int(size/1460) + 2
        for _ in (0..<30){
            let response = self.receiveAll(size: size)
            if (self.image.count == size || response == 0 ){
                break
            }
        }
        return self.image
    }
    
    func receiveAll(size: Int)->Int {
        var byte_count: Int = 0
        let receiveAll_semaphone: DispatchSemaphore = DispatchSemaphore(value: 0)
        nwConnection.receiveMessage(completion: { (data, _, isComplete, error) in
            if isComplete {
                if let data = data, !data.isEmpty {
                    byte_count = data.count
                    self.image.append(data)
                    NSLog("receivelAll data: \(self.image.count)")
                }
            } else if let error = error {
                NSLog("setupReceiveAll connection error \(error)")
            } else {
                NSLog("setupReceiveAll inComplete \(self.image.count)")
            }
            _ = receiveAll_semaphone.signal()
        })
        _ = receiveAll_semaphone.wait(timeout: .now() + DispatchTimeInterval.seconds(2))
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
        self.nwConnection.cancel()
        while(nwConnection.state != NWConnection.State.cancelled){
            sleep(1)
            NSLog("waiting for connection to be cancelled")
        }
        NSLog("XXXXXX  Connection Ends XXXXX")
    }
}


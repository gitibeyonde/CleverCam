//
//  ClientConnection.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 05/02/22.
//

import Foundation
import Network


protocol ConnectionListener {
    func listen(response: Data)->Void
}


@available(macOS 10.14, *)
class ClientConnection {

    let nwConnection: NWConnection
    let queue: DispatchQueue
    var listener: ConnectionListener
    public var type: String = ""
    public var min_size: Int = 6
    public var max_size: Int = 128
    var image: Data = Data()

    init(nwConnection: NWConnection) {
        self.queue = DispatchQueue.global()
        self.nwConnection = nwConnection
        self.listener = DefaultListener()
    }

    var didStopCallback: ((Error?) -> Void)? = nil

    func start(listener: ConnectionListener) {
        self.listener = listener
        nwConnection.stateUpdateHandler = stateDidChange(to:)
        print("Connection state ",nwConnection.state)
        nwConnection.start(queue: queue)
        while(nwConnection.state != NWConnection.State.ready){
            sleep(1)
            print("waiting for connection to be ready")
        }
        setupReceive()
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
            case .setup:
                print("Client connection setup")
            case .waiting( _):
                print("Client connection waiting")
            case .preparing:
                print("Client connection preparing")
            case .ready:
                print("Client connection ready")
            case .cancelled:
                print("Client connection cancelled")
                cancel(error: nil)
            case .failed(let error):
                print("Client connection failed")
                connectionDidFail(error: error)
            default:
                break
        }
    }

    public func setImage(size: Int){
        self.type = "IMAGE"
        self.min_size = size
        self.max_size = size
        self.image = Data()
    }
    
    public func unsetImage(){
        self.type = ""
        self.min_size = 6
        self.max_size = 1460
    }
    
    public func isImage()->Bool {
        return self.type == "IMAGE"
    }
    
    public func setupReceive() {
        //print("setupReceive")
        nwConnection.receive(minimumIncompleteLength: self.min_size, maximumLength: self.max_size) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                if self.isImage() {
                    self.image.append(data)
                    if (self.min_size == self.image.count) {
                        self.listener.listen(response: self.image)
                    }
                }
                else {
                    self.listener.listen(response: data)
                }
            }
            if isComplete {
                //print("setupReceive connection complete")
                //self.connectionDidEnd()
                self.setupReceive()
            } else if let error = error {
                print("setupReceive connection error")
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }

    func send(data: Data) {
        nwConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                print("send connection error")
                self.connectionDidFail(error: error)
                return
            }
            print("UDP>",String(decoding: data, as: UTF8.self))
        }))
    }
    
    private func connectionDidFail(error: Error) {
        print("connection did fail, error: \(error)")
        cancel(error: error)
    }

    private func connectionDidEnd() {
        print("connection did end")
        cancel(error: nil)
    }

    public func cancel(error: Error?) {
        self.nwConnection.stateUpdateHandler = nil
        //self.nwConnection.cancel()
        self.nwConnection.forceCancel()
        print("XXXXXX  Connection Ends XXXXX")
    }
}


class DefaultListener: ConnectionListener {
    func listen(response: Data) {
        print("DefaultListener<:", String(decoding: response, as: UTF8.self))
    }
}

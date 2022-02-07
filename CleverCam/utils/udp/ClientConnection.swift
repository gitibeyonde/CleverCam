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

    public func setupReceive() {
        print("setupReceive")
        nwConnection.receive(minimumIncompleteLength: 6, maximumLength: Int.max) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                self.listener.listen(response: data)
                print("UDP<",String(decoding: data, as: UTF8.self))
            }
            if isComplete {
                print("setupReceive connection complete")
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

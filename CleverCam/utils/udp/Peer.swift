//
//  Broker.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 05/02/22.
//

import Foundation
import Network

@available(macOS 10.14, *)
class Peer {
    let _peer_connection: ClientConnection
    let _device_uuid: String
    
    // PEER CONNECTION
    init(peer_host: String, peer_port: UInt16, my_host: String, my_port: UInt16, device_uuid: String) {
        self._device_uuid = device_uuid
        NSLog("Peer host=\(peer_host), port=\(peer_port)")
        let phost = NWEndpoint.Host(peer_host)
        let pport = NWEndpoint.Port("\(peer_port)")!
        
        let mhost = NWEndpoint.Host(my_host)
        let mport = NWEndpoint.Port("\(my_port)")!
        let connectionParams = NWParameters.udp
        //connectionParams.allowLocalEndpointReuse = true
        //connectionParams.allowFastOpen = true
        //connectionParams.includePeerToPeer = true
        connectionParams.requiredLocalEndpoint = NWEndpoint.hostPort(host: mhost, port: mport)
        let nwConnection = NWConnection(host: phost, port: pport, using: connectionParams)
        _peer_connection = ClientConnection(nwConnection: nwConnection)
    }

    func start() {
        _peer_connection.didStopCallback = didStopCallback(error:)
        
        _peer_connection.start()
        
        var result: Bool = false
        while (result == false) {
            result = self._peer_connection.isReady()
            if result == false {
                sleep(1)
            }
        }
    }
    
    func cancel(){
        _peer_connection.cancel(error: nil)
        var result: Bool = false
        while (result == false) {
            result = self._peer_connection.isCancelled()
            if result == false {
                sleep(1)
            }
        }
    }
    
    func didStopCallback(error: Error?) {
        if error == nil {
            exit(EXIT_SUCCESS)
        } else {
            exit(EXIT_FAILURE)
        }
    }

    
    func requestDHINJPeer() -> Data {
        let cmd_str: String = "DHINJ:\(self._device_uuid):"
        let cmd: Data = cmd_str.data(using: .utf8)!
        NSLog("Peer>\(String(decoding: cmd, as: UTF8.self))")
        
        let response:Data = _peer_connection.send(request: cmd)
        
        if response.starts(with: Data(bytes: "SIZE:", count: 5)) {
            NSLog("Peer<:\(String(decoding: response, as: UTF8.self))")
            let vc = response.split(separator: 58)[1].split(separator: 46)
            let size: Int = Int(String(decoding: vc[1], as: UTF8.self))!
            _peer_connection.resetImage()
            return _peer_connection.receiveImage(size: size)
        }
        else {
            NSLog("Peer<BAD>:\(response.count)")
            return Data()
        }
    }
    
    
}


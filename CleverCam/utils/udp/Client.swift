//
//  Broker.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 05/02/22.
//

import Foundation
import Network

@available(macOS 10.14, *)
class Client {
    let _connection: ClientConnection
    let _device_uuid: String
    
    init(device_uuid: String) {
        self._device_uuid = device_uuid
        let host = NWEndpoint.Host("broker.ibeyonde.com")
        let port = NWEndpoint.Port(rawValue: 5020)!
        let connectionParams = NWParameters.udp
        connectionParams.requiredLocalEndpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(NetUtils._my_host), port: NWEndpoint.Port("\(NetUtils._my_port)")!)
        let nwConnection = NWConnection(host: host, port: port, using: connectionParams)
        _connection = ClientConnection(nwConnection: nwConnection)
    }
    
    init(peer_host: String, peer_port: UInt16, device_uuid: String) {
        self._device_uuid = device_uuid
        NSLog("Peer host=\(peer_host), port=\(peer_port)")
        let host = NWEndpoint.Host(peer_host)
        let port = NWEndpoint.Port("\(peer_port)")!
        let connectionParams = NWParameters.udp
        connectionParams.allowLocalEndpointReuse = true
        connectionParams.requiredLocalEndpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(NetUtils._my_host), port: NWEndpoint.Port("\(NetUtils._my_port)")!)
        let nwConnection = NWConnection(host: host, port: port, using: connectionParams)
        _connection = ClientConnection(nwConnection: nwConnection)
        
    }

    func start() {
        _connection.didStopCallback = didStopCallback(error:)
        _connection.start()
    }

    func cancel(){
        _connection.cancel(error: nil)
    }
    
    func didStopCallback(error: Error?) {
        if error == nil {
            exit(EXIT_SUCCESS)
        } else {
            exit(EXIT_FAILURE)
        }
    }
    
    
    func register(my_uuid: String, my_host: String, my_port: UInt16) -> Bool {
        let cmd_str: String = "REGISTER:\(my_uuid):"
        var cmd: Data = cmd_str.data(using: .utf8)!
        let addressData: Data = IpUtils.addressToBytes(ip: my_host, port: my_port)
        cmd.append(addressData)
        NSLog("Broker>\(String(decoding: cmd, as: UTF8.self))")
        
        let response:Data = _connection.send(request: cmd)
        
        if response.starts(with: Data(bytes: "RREG:", count: 5)) {
            NSLog("Broker<:\(String(decoding: response, as: UTF8.self))")
            return true
        }
        else {
            NSLog("Broker<BAD>:\(String(decoding: response, as: UTF8.self))")
            sleep(1)
            return false
        }
    }
    
    func getPeerAddress() -> (String, UInt16) {
        let cmd_str: String = "PADDR:\(self._device_uuid):"
        let cmd: Data = cmd_str.data(using: .utf8)!
        NSLog("Broker>\(String(decoding: cmd, as: UTF8.self))")
        
        let response:Data = _connection.send(request: cmd)
        
        if response.starts(with: Data(bytes: "RPADDR:", count: 7)) {
            NSLog("Broker<:\(String(decoding: response, as: UTF8.self))")
            let result = IpUtils.getAddress(dp: response)
            return result
        }
        else {
            NSLog("Broker<BAD>:\(String(decoding: response, as: UTF8.self))")
            sleep(1)
            return ("", 0)
        }
    }
    
    func requestDHINJPeer() -> Data {
        let cmd_str: String = "DHINJ:\(self._device_uuid):"
        let cmd: Data = cmd_str.data(using: .utf8)!
        NSLog("Peer>\(String(decoding: cmd, as: UTF8.self))")
        
        let response:Data = _connection.send(request: cmd)
        
        if response.starts(with: Data(bytes: "SIZE:", count: 5)) {
            NSLog("Peer<:\(String(decoding: response, as: UTF8.self))")
            let vc = response.split(separator: 58)[1].split(separator: 46)
            let size: Int = Int(String(decoding: vc[1], as: UTF8.self))!
            NSLog("Size=\(size)")
            _connection.resetImage()
            return _connection.receiveImage(size: size)
        }
        else {
            NSLog("Peer<BAD>:\(response.count)")
            return Data()
        }
    }
    
    
}


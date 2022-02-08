//
//  Broker.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 05/02/22.
//

import Foundation
import Network

@available(macOS 10.14, *)
class Client : ConnectionListener {
    let _connection: ClientConnection
    let _device_uuid: String
    var _image: Data = Data()
    
    init(device_uuid: String) {
        let host = NWEndpoint.Host("broker.ibeyonde.com")
        let port = NWEndpoint.Port(rawValue: 5020)!
        let connectionParams = NWParameters.udp
        connectionParams.allowLocalEndpointReuse = true
        connectionParams.requiredLocalEndpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(NetUtils._my_host), port: NWEndpoint.Port("\(NetUtils._my_port)")!)
        let nwConnection = NWConnection(host: host, port: port, using: connectionParams)
        _connection = ClientConnection(nwConnection: nwConnection)
        self._device_uuid = device_uuid
    }
    
    init(peer_host: String, peer_port: UInt16, device_uuid: String) {
        print("Peer host=\(peer_host), port=\(peer_port)")
        let host = NWEndpoint.Host(peer_host)
        let port = NWEndpoint.Port("\(peer_port)")!
        let connectionParams = NWParameters.udp
        connectionParams.allowLocalEndpointReuse = true
        connectionParams.requiredLocalEndpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(NetUtils._my_host), port: NWEndpoint.Port("\(NetUtils._my_port)")!)
        let nwConnection = NWConnection(host: host, port: port, using: connectionParams)
        _connection = ClientConnection(nwConnection: nwConnection)
        self._device_uuid = device_uuid
        
    }

    func start(listener: ConnectionListener) {
        _connection.didStopCallback = didStopCallback(error:)
        _connection.start(listener: listener)
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
    
    
    func register(my_uuid: String, my_host: String, my_port: UInt16) -> Void {
        let cmd_str: String = "REGISTER:\(my_uuid):"
        var cmd: Data = cmd_str.data(using: .utf8)!
        let addressData: Data = IpUtils.addressToBytes(ip: my_host, port: my_port)
        cmd.append(addressData)
        print("Broker>", String(decoding: cmd, as: UTF8.self))
        
        _connection.send(data: cmd)
    }
    
    func askPeerAddress() -> Void {
        let cmd_str: String = "PADDR:\(self._device_uuid):"
        let cmd: Data = cmd_str.data(using: .utf8)!
        print("Broker>", cmd_str)
        
        _connection.send(data: cmd)
    }
    
    func requestDHINJPeer() -> Void {
        let cmd_str: String = "DHINJ:\(self._device_uuid):"
        let cmd: Data = cmd_str.data(using: .utf8)!
        print("Peer>", cmd_str)
        
        _connection.send(data: cmd)
    }
    
    func getImage()->Data {
        sleep(1)
        return self._image
    }
    
    func listen(response: Data) {
        if (_connection.isImage()){
            print("Peer Image<",response)
            _connection.unsetImage()
            _image = response
        }
        else if response.starts(with: Data(bytes: "RREG", count: 4)) {
            print("Broker<:", String(decoding: response, as: UTF8.self))
            print("Device registration done")
        }
        else if response.starts(with: Data(bytes: "RPADDR", count: 6)) {
            print("Broker<:", String(decoding: response, as: UTF8.self))
            let result = IpUtils.getAddress(dp: response)
            NetUtils._peer_host = result.0
            NetUtils._peer_port = result.1
        }
        else if response.starts(with: Data(bytes: "SIZE", count: 4)) {
            print("Peer<:", String(decoding: response, as: UTF8.self))
            let vc = response.split(separator: 58)[1].split(separator: 46)
            let size: Int = Int(String(decoding: vc[1], as: UTF8.self))!
            print("Size=",size)
            _connection.setImage(size: size)
        }
        else {
         print("UDP Unknown response",response)
        }
     }
    
}


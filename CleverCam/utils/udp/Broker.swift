//
//  Broker.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 05/02/22.
//

import Foundation
import Network

@available(macOS 10.14, *)
class Broker {
    let _broker_connection: ClientConnection
    
    //BROKER CONNECTION
    init(my_host: String, my_port: UInt16) {
        let bhost = NWEndpoint.Host("broker.ibeyonde.com")
        let bport = NWEndpoint.Port(rawValue: 5020)!
        let mhost = NWEndpoint.Host(my_host)
        let mport = NWEndpoint.Port("\(my_port)")!
        NSLog("My host=\(my_host), port=\(my_port)")
        let connectionParams = NWParameters.udp
        connectionParams.allowLocalEndpointReuse = true
        //connectionParams.allowFastOpen = true
        //connectionParams.includePeerToPeer = true
        connectionParams.requiredLocalEndpoint = NWEndpoint.hostPort(host: mhost, port: mport)
        let nwConnection = NWConnection(host: bhost, port: bport, using: connectionParams)
        _broker_connection = ClientConnection(nwConnection: nwConnection)
    }
    
    init(){
        _broker_connection = ClientConnection()
    }

    func start() {
        _broker_connection.didStopCallback = didStopCallback(error:)
        
        _broker_connection.start()
        
        var result: Bool = false
        while (result == false) {
            result = self._broker_connection.isReady()
            if result == false {
                sleep(1)
            }
        }
    }
    
    func cancel(){
        _broker_connection.cancel(error: nil)
        var result: Bool = false
        while (result == false) {
            result = self._broker_connection.isCancelled()
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
    
    
    func register(my_uuid: String, my_host: String, my_port: UInt16) -> Bool {
        let cmd_str: String = "REGISTER:\(my_uuid):"
        var cmd: Data = cmd_str.data(using: .utf8)!
        let addressData: Data = IpUtils.addressToBytes(ip: my_host, port: my_port)
        cmd.append(addressData)
        NSLog("Broker>\(String(decoding: cmd, as: UTF8.self))")
        
        let response:Data = _broker_connection.send(request: cmd)
        
        if response.starts(with: Data(bytes: "RREG:", count: 5)) {
            NSLog("Broker<:\(String(decoding: response, as: UTF8.self))")
            return true
        }
        else {
            NSLog("Broker<BAD>:\(String(decoding: response, as: UTF8.self))")
            return false
        }
    }
    
    func getPeerAddress(device_uuid: String) -> (String, UInt16) {
        let cmd_str: String = "PADDR:\(device_uuid):"
        let cmd: Data = cmd_str.data(using: .utf8)!
        NSLog("Broker>\(String(decoding: cmd, as: UTF8.self))  \(_broker_connection.nwConnection.state)")
        
        let response:Data = _broker_connection.send(request: cmd)
        
        if response.starts(with: Data(bytes: "RPADDR:", count: 7)) {
            NSLog("Broker<\(String(decoding: response, as: UTF8.self))")
            let result = IpUtils.getAddress(dp: response)
            return result
        }
        else {
            NSLog("Broker<BAD>\(String(decoding: response, as: UTF8.self))")
            return ("", 0)
        }
    }
    
    func kickStartGetImage(device_uuid: String) -> Void {
        let cmd_str: String = "HINI:\(device_uuid):"
        let cmd: Data = cmd_str.data(using: .utf8)!
        NSLog("Broker>\(String(decoding: cmd, as: UTF8.self))")
        
        let response:Data =  _broker_connection.send(request: cmd)
        NSLog("Broker<\(String(decoding: response, as: UTF8.self))")
    }
    
}


//
//  NetUtils.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 06/02/22.
//

import Foundation


class NetUtils {
    
    public static var _peer_host: String = ""
    public static var _peer_port: UInt16 = 1
    public static var _my_host: String = ""
    public static var _my_port: UInt16 = 1
    public static var _device_uuid: String = ""
    public static var _my_uuid: String = ""
    var client:Client
    
    private static var _is_init: Bool = false
    
    init(my_uuid: String, device_uuid: String){
        NetUtils._is_init = true
        NetUtils._my_uuid = my_uuid
        NetUtils._device_uuid = device_uuid
        NetUtils._my_host = IpUtils.getMyIPAddresses()
        NetUtils._my_port = IpUtils.getMyPort()
        print("My host = \(NetUtils._my_host), My Port=\(NetUtils._my_port)")
        self.client = Client(device_uuid: NetUtils._device_uuid)
        self.client.start(listener: self.client)
    }
    
    init(my_uuid: String, device_uuid: String, host: String, port: UInt16){
        NetUtils._is_init = true
        NetUtils._my_uuid = my_uuid
        NetUtils._device_uuid = device_uuid
        NetUtils._my_host = IpUtils.getMyIPAddresses()
        NetUtils._my_port = IpUtils.getMyPort()
        print("My host = \(NetUtils._my_host), My Port=\(NetUtils._my_port)")
        //self.client = Client(device_uuid: NetUtils._device_uuid)
        //self.client.start(listener: self.client)
        NetUtils._peer_host = host
        NetUtils._peer_port = port
        self.client = Client(peer_host: NetUtils._peer_host, peer_port: NetUtils._peer_port, device_uuid: NetUtils._device_uuid)
        self.client.start(listener: client)
    }
    
    public func register(){
        self.client.register(my_uuid: NetUtils._my_uuid, my_host: NetUtils._my_host, my_port: NetUtils._my_port)
    }
    
    
    public func getPeerAddress(){
        self.client.askPeerAddress()
    }
    
    public func cancelBroker(){
        self.client.cancel()
    }
    
    public func initPeer(){
        self.client = Client(peer_host: NetUtils._peer_host, peer_port: NetUtils._peer_port, device_uuid: NetUtils._device_uuid)
        self.client.start(listener: client)
    }
    
    public func getImageFromPeer(){
        self.client.requestDHINJPeer()
    }
    
    public func cancelPeer(){
        self.client.cancel()
    }
}

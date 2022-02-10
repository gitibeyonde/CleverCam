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
    
    init(device_uuid: String){
        NetUtils._device_uuid = device_uuid
        NetUtils._my_host = IpUtils.getMyIPAddresses()
        NetUtils._my_port = IpUtils.getMyPort()
        print("My host = \(NetUtils._my_host), My Port=\(NetUtils._my_port)")
        self.client = Client(device_uuid: NetUtils._device_uuid)
        self.client.start()
    }
    
    init(){
        print("Peer host = \(NetUtils._peer_host), My Port=\(NetUtils._peer_port)")
        self.client = Client(peer_host: NetUtils._peer_host, peer_port: NetUtils._peer_port, device_uuid: NetUtils._device_uuid)
        self.client.start()
    }
    
    public func isReady()->Bool {
        return self.client.isReady()
    }
    
    public func register(my_uuid: String)->Bool {
        NetUtils._my_uuid = my_uuid
        return  self.client.register(my_uuid: NetUtils._my_uuid, my_host: NetUtils._my_host, my_port: NetUtils._my_port)
    }
    
    
    public func getPeerAddress() -> Bool {
            let pa = self.client.getPeerAddress()
            if (pa.1 > 0) {
                NetUtils._peer_host = pa.0
                NetUtils._peer_port = pa.1
                return true
            }
            else {
                return false
            }
    }
    
    public func cancelBroker(){
        self.client.cancel()
    }
    
    public func getImageFromPeer()->Data {
        return self.client.requestDHINJPeer()
    }
    
    public func cancelPeer(){
        self.client.cancel()
    }
}

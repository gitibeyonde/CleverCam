//
//  IpUtils.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 05/02/22.
//

import Foundation
import Network


public class IpUtils {
    
    static var min_udp_port:UInt16 = 20000
    static var max_udp_port:UInt16 = 65534
    
    static func getMyIPAddresses() -> String {
        var addresses = [String]()
     
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "0.0.0.0" }
        guard let firstAddr = ifaddr else { return "0.0.0.0" }
     
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
     
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) {//|| addr.sa_family == UInt8(AF_INET6) {
     
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        print(addresses)
        if (addresses.count == 1){
            return addresses[0]
        }
        else if (addresses.count == 2){
            return addresses[1]
        }
        else {
            return addresses[0]
        }
    }
    
    public static func getMyPort()->UInt16 {
        return  UInt16.random(in: min_udp_port..<max_udp_port)
    }
    
    
    public static func getAddress(dp: Data) -> (String, UInt16) {
        var data:Data.Iterator = dp.makeIterator()
        var address: [UInt8] = [ 0, 0, 0, 0, 0, 0 ]
        var i: Int = 0
        var toggle: Bool = false
        while let byte = data.next() {
            if toggle {
                address[i] = byte
                i += 1
            }
            if byte == 58 {
                toggle = true
            }
            if byte == 6 {
                toggle = false
            }
        }
        
        let ip: String = bytesGetIp(bt: address);
        let pt: UInt16 = bytesGetPort(bt: address);
        //print("---getAddress \(ip):\(pt)");
        return (ip, pt)
    }

    
    public static func bytesGetIp(bt: [UInt8]) -> String {
        if (bt.count != 6) {
            //print("byteToIp bad byte array \(bt.count)");
            return "";
        }
        return "\(bt[0]).\(bt[1]).\(bt[2]).\(bt[3])";
    }
    
    
    public static func ipToBytes(ipAddress: String) -> Data {
        //print("ipToBytes < ",ipAddress)
        let ipAddressInArray: [String] = ipAddress.components(separatedBy: ".");
        var result:Data = Data()
        for i in 0..<ipAddressInArray.count {
            result.append(UInt8(ipAddressInArray[i])!);
        }
        //print("ipToBytes > ",result as NSData)
        return result;
    }
    
    public static func bytesGetPort(bt: [UInt8]) -> UInt16 {
        if (bt.count != 6) {
            //print("byteToIp bad byte array \(bt.count)");
            return 0;
        }
        return (UInt16(bt[5]) << 8)  | UInt16(bt[4])
    }
    
    public static func portToBytes(port: UInt16) -> Data {
        //print("portToBytes < \(port)")
        var result:Data = Data()
        result.append(UInt8(port & 0xFF))
        result.append(UInt8(port >> 8 & 0xFF))
        //print("portToBytes > \(result as NSData)")
        return result
    }
    
    public static func addressToBytes(ip : String, port: UInt16) -> Data {
        var bt:Data = Data()
        bt.append(ipToBytes(ipAddress: ip))
        bt.append(portToBytes(port: port))
        return bt;
    }
    
    
}

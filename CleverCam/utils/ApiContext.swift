//
//  IotApiContext.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 16/10/21.
//

import Foundation


class ApiContext: NSObject {
    
    static let shared = ApiContext()
    
    public var deviceList:Array<Device> = []
    public func setDeviceList(deviceList: Array<Device>)->Void {
        self.deviceList = deviceList
    }
    public func getDeviceList()->Array<Device> {
        return self.deviceList;
    }
    public func getDeviceAlerts(uuid: String)->Device {
        for device in deviceList {
            if device.uuid == uuid {
                return device
            }
        }
        return Device()
    }
    public func getDevice(index: Int)->Device {
        return deviceList[index]
    }
    
    public var deviceAlertList:Array<DeviceAlerts> = []
    public func setDeviceAlerts(uuid: String, alertList: Array<Alert>)->Void {
        var deviceAlerts : DeviceAlerts = DeviceAlerts()
        deviceAlerts.uuid = uuid
        deviceAlerts.alertlist = alertList
        deviceAlertList.append(deviceAlerts)
    }
    
    public func getDeviceAlerts(uuid: String)->Array<Alert> {
        for alertcombo in deviceAlertList {
            if alertcombo.uuid == uuid {
                return alertcombo.alertlist
            }
        }
        return Array<Alert>()
    }
    public func getDeviceAlerts(index: Int)->Array<Alert> {
        return deviceAlertList[index].alertlist
    }
    
    public func allDeviceAlertsAvailable()->Bool {
        return deviceList.count == deviceList.count
    }
    
    var cache:[URL: Data] = [URL: Data]()
    
    public func addImage(url: URL, data: Data)->Void {
        cache[url] = data
    }
    
    public func getImage(url: URL)->Data {
        return cache[url] ?? Data.init()
    }
}

//
//  IotApiContext.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 16/10/21.
//

import Foundation
import CryptoKit


class ApiContext: NSObject {
    
    static let shared = ApiContext()
    
    public var veil:String=""
    
    /*
     DEVICE LIST
     */
    public var deviceList:Array<Device> = []
    public func setDeviceList(deviceList: Array<Device>)->Void {
        self.deviceList = deviceList
    }
    public func getDeviceList()->Array<Device> {
        return self.deviceList;
    }
    public func getDevice(uuid: String)->Device {
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
    public func moveDeviceToTop(index: Int)->Void {
        let topDevice = deviceList[0]
        deviceList[0] = deviceList[index]
        deviceList[index] = topDevice
    }
    public func getDeviceName(uuid: String)->String {
        for device in deviceList {
            if device.uuid == uuid {
                return device.device_name
            }
        }
        return uuid
    }
    
    /*
     DEVICE ALERTS
     */
    public var deviceAlertList:Array<DeviceAlerts> = []
    public func setDeviceAlerts(uuid: String, alertList: Array<Alert>)->Void {
        //check if uuid exists
        for (index, element) in deviceAlertList.enumerated() {
            if element.uuid == uuid {
                deviceAlertList[index].alertlist = alertList
                return
            }
        }
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
        return deviceList.count == deviceAlertList.count
    }
    
    /*
     DEVICE HISTORY
     */
    public var deviceHistoryList:Array<DeviceHistory> = []
    public func setDeviceHistory(uuid: String,  historyList: Array<History>)->Void {
        var deviceHistory : DeviceHistory = DeviceHistory()
        deviceHistory.uuid = uuid
        deviceHistory.historylist = historyList
        deviceHistoryList.append(deviceHistory)
    }
    
    public func getDeviceHistory(uuid: String)->Array<History> {
        for alertcombo in deviceHistoryList {
            if alertcombo.uuid == uuid {
                return alertcombo.historylist
            }
        }
        return Array<History>()
    }
    public func getDeviceHistory(index: Int)->Array<History> {
        return deviceHistoryList[index].historylist
    }
    
    public func allDeviceHistoryAvailable()->Bool {
        return deviceList.count == deviceHistoryList.count
    }
    /*
     NOTIFICATION
     */
    public var notificationList: Array<CCNotification> = Array<CCNotification>()
    public func setNotification(nl: Array<CCNotification>){
        notificationList = nl
    }
    public func getNotification()->Array<CCNotification>{
        return notificationList;
    }
    
    /*
     CACHE
     */
    var cache:[String: Data] = [String: Data]()
    public func addImage(url: String, data: Data)->Void {
        cache[md5(str: url)] = data
    }
    
    public func getImage(url: String)->Data {
        return cache[md5(str: url)] ?? Data.init()
    }
    
    private func md5(str: String)-> String {
        let us = str.components(separatedBy: "data.ibeyonde")[1]
        let ind = us.components(separatedBy: "?")[0]
        return ind
    }
    
    /*
     DEVICE HISTORY
     */
    public var bellHistoryList:Array<BellHistory> = []
    public func setBellHistory(bellHistoryList: Array<BellHistory>)->Void {
        self.bellHistoryList=bellHistoryList
    }
    
    public func getBellHistory(uuid: String)->Array<BellHistory> {
        return bellHistoryList
    }
    
}

//
//  HttpRequest.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import Foundation
import UIKit

protocol HttpRequestDelegate: class {
    func onError()
}

public class HttpRequest: HttpRequestDelegate {
    
    public typealias SuccessCompletionHandler = (_ response: String) -> Void
    public typealias DeviceSuccessCompletionHandler = (_ response: Array<Device>) -> Void
    public typealias AlertSuccessCompletionHandler = (_ response: Array<Alert>) -> Void
    public typealias HistorySuccessCompletionHandler = (_ response: Array<History>) -> Void
    public typealias NotificationSuccessCompletionHandler = (_ response: Array<Notification>) -> Void
    public typealias BellHistorySuccessCompletionHandler = (_ response: Array<BellHistory>) -> Void
    public typealias ConfigSuccessCompletionHandler = (_ response: Array<CameraConfig>) -> Void
   
    
    static func login(_ delegate: HttpRequestDelegate?, base64LoginString: String,
                    success successCallback: @escaping SuccessCompletionHandler
    ) {
        let url = "https://ping.ibeyonde.com/api/iot.php?view=login"
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    //send this block to required place
                    let respstr = String(decoding: data, as: UTF8.self)
                    print("Response " + respstr)
                    successCallback(respstr)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    
    //"https://ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=" + uuid;
    static func deviceList(_ delegate: HttpRequestDelegate?,
                    success successCallback: @escaping DeviceSuccessCompletionHandler
    ) {
        let url = "https://ping.ibeyonde.com/api/iot.php?view=devicelist"
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }
        
        let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let deviceList:Array<Device> = try decoder.decode([Device].self, from: data)
                        ApiContext.shared.setDeviceList(deviceList: deviceList)
                        successCallback(deviceList)
                    }
                    catch {
                        print("Something went wrong")
                        delegate?.onError()
                    }
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    
    //"https://ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=" + uuid;
    static func lastAlerts(_ delegate: HttpRequestDelegate?, uuid: String,
                    success successCallback: @escaping AlertSuccessCompletionHandler
    ) {
        let url = "https://ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=" + uuid;
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }
        
        let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    var alertList: Array<Alert> = Array<Alert>()
                    do {
                        let jsonObjects: [Array] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [Array<String>]
                        for jsonObject in jsonObjects {
                            alertList.append(Alert(url: jsonObject[0], time: jsonObject[1]))
                        }
                        ApiContext.shared.setDeviceAlerts(uuid: uuid, alertList: alertList)
                    }
                    catch {
                        print("Something went wrong")
                    }
                    successCallback(alertList)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    
    //"https://ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=" + uuid;
    static func history(_ delegate: HttpRequestDelegate?, uuid: String,
                    success successCallback: @escaping HistorySuccessCompletionHandler
    ) {
        let url = "https://ping.ibeyonde.com/api/iot.php?view=lastalerts&cnt=20&uuid=" + uuid;
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }
        
        let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    var historyList: Array<History> = Array<History>()
                    do {
                        let jsonObjects: [Array] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [Array<String>]
                        for jsonObject in jsonObjects {
                            historyList.append(History(url: jsonObject[0], time: jsonObject[1]))
                        }
                        ApiContext.shared.setDeviceHistory(uuid: uuid, historyList: historyList)
                    }
                    catch {
                        print("Something went wrong")
                    }
                    successCallback(historyList)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    
    static func getStreamUrl(_ delegate: HttpRequestDelegate?, uuid: String
    ) -> String {
        
        var device:Device = ApiContext.shared.getDevice(uuid: LiveViewController.uuid)
        if device.uuid == "" {
            let url = "https://ping.ibeyonde.com/api/iot.php?view=devicelist"
            guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
                delegate?.onError()
                return String()
            }
            
            let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()

            var request = URLRequest(url: usableUrl)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
            
            var dataTask: URLSessionDataTask?
            let defaultSession = URLSession(configuration: .default)
            
            let semaphore = DispatchSemaphore(value: 0)
            dataTask =
                defaultSession.dataTask(with: request) { data, response, error in
                    defer {
                        dataTask = nil
                    }
                    if error != nil {
                        delegate?.onError()
                    } else if
                        let data: Data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        do {
                            let decoder = JSONDecoder()
                            let deviceList:Array<Device> = try decoder.decode([Device].self, from: data)
                            ApiContext.shared.setDeviceList(deviceList: deviceList)
                            print("Device list set ", deviceList)
                        }
                        catch {
                            print("Something went wrong")
                            delegate?.onError()
                        }
                    }
                    else {
                        print("Unknown error")
                        delegate?.onError()
                    }
                    
                    print("Running", BellAlertViewController.uuid)
                    semaphore.signal()
            }
            dataTask?.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            print("Resume")
            device = ApiContext.shared.getDevice(uuid: BellAlertViewController.uuid)
        }
        print(" Have device url ", device)
        
        
        var validLocalURL: String = "http://\(device.deviceip)"
        //if not lets call the delegate to manage the error
        guard let urlComponent1 = URLComponents(string: validLocalURL), let usableUrl1 = urlComponent1.url else {
          delegate?.onError()
          return String()
        }

        var request = URLRequest(url: usableUrl1)
        request.httpMethod = "GET"

        var dataTask1: URLSessionDataTask?
        let defaultSession1 = URLSession(configuration: .default)
        let semaphore1 = DispatchSemaphore(value: 0)
        print("get local url")
        dataTask1 = defaultSession1.dataTask(with: request) { data, response, error in
            defer {
                dataTask1 = nil
            }
            if error != nil {
                delegate?.onError()
            } else if
                let data: Data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                //send this block to required place
                let respstr = String(decoding: data, as: UTF8.self)
                if !respstr.contains("Ibeyonde Cam") {
                    validLocalURL = String()
                }
            }
            else {
              print("Unknown error")
              delegate?.onError()
            }
            print("getting local url")
            semaphore1.signal()
        }
        dataTask1?.resume()
        _ = semaphore1.wait(timeout: DispatchTime.distantFuture)
        print("got local url ", validLocalURL)
        
        
        if !validLocalURL.isEmpty {
            return "\(validLocalURL)/stream"
        }
        
        //get the remote url
        let url:String = "https://ping.ibeyonde.com/api/iot.php?view=live&quality=HINI&uuid=" + uuid;
        
        var validRemoteURL: String = String()
      //We need to be sure that we have an usable url to make the request,
      //if not lets call the delegate to manage the error
        guard let urlComponent2 = URLComponents(string: url), let usableUrl2 = urlComponent2.url else {
            delegate?.onError()
            return String()
        }
        
        let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        request = URLRequest(url: usableUrl2)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask2: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        let semaphore2 = DispatchSemaphore(value: 0)
        dataTask2 =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask2 = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    //send this block to required place
                    validRemoteURL = String(bytes: data, encoding: .ascii) ?? ""
                    validRemoteURL = validRemoteURL.replacingOccurrences(of: "\\/", with: "/")
                    validRemoteURL = validRemoteURL.replacingOccurrences(of: "\"", with: "")
                    print("Response " + validRemoteURL)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
                print("getting remote url")
                semaphore2.signal()
        }
        dataTask2?.resume()
        _ = semaphore2.wait(timeout: DispatchTime.distantFuture)
        print("got remote url ", validRemoteURL)
        return validRemoteURL
    }
    
    static func notifications(_ delegate: HttpRequestDelegate?,
                    success successCallback: @escaping NotificationSuccessCompletionHandler
    ) {
        let url = "https://ping.ibeyonde.com/api/iot.php?view=lastalerts&type=bp"
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }
        
        let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    var notificationList: Array<Notification> = Array<Notification>()
                    do {
                        let jsonObjects: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [NSDictionary]
                        for jsonObject in jsonObjects {
                            notificationList.append(Notification(uuid: jsonObject["uuid"] as! String, id: jsonObject["id"] as! String, created: jsonObject["created"] as! String, image: jsonObject["image"] as! String, type: jsonObject["type"] as! String
                            ))
                        }
                        ApiContext.shared.setNotification(nl: notificationList)
                    }
                    catch {
                        print("Something went wrong")
                    }
                    successCallback(notificationList)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    
   
    static func bellAlertDetails(_ delegate: HttpRequestDelegate?, uuid: String, datetime: String,
                    success successCallback: @escaping BellHistorySuccessCompletionHandler
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: datetime)
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date!)
        let month = calendar.component(.month, from: date!)
        let day = calendar.component(.day, from: date!)
        let hour = calendar.component(.hour, from: date!)
        let minute = calendar.component(.minute, from: date!)
        
        let url = "https://ping.ibeyonde.com/api/iot.php?view=bellalerts&uuid=\(uuid)&date=\(year)/\(month)/\(day)&hour=\(hour)&minute=\(minute)";
        
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }
        
        let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    var bellHistoryList: Array<BellHistory> = Array<BellHistory>()
                    do {
                        let jsonObjects: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [NSDictionary]
                        for jsonObject in jsonObjects {
                            bellHistoryList.append(BellHistory(url: jsonObject["url"] as! String, time: jsonObject["datetime"] as! String))
                        }
                        ApiContext.shared.setBellHistory(bellHistoryList: bellHistoryList)
                    }
                    catch {
                        print("Something went wrong")
                    }
                    successCallback(bellHistoryList)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    
    /**
                            SETTINGS
     */
    static func settings(_ delegate: HttpRequestDelegate?, uuid: String,
                    success successCallback: @escaping ConfigSuccessCompletionHandler
    ) {
        let device = ApiContext.shared.getDevice(uuid: uuid);
        let url = "http://\(device.deviceip)/cmd?name=getconf";
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }
        
        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("localhost", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    var config: Array<CameraConfig> = Array<CameraConfig>()
                    print(response)
                    do {
                        let jsonObjects: [Array] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [Array<String>]
                        for jsonObject in jsonObjects {
                            config.append(CameraConfig(name: jsonObject[0], value: jsonObject[1]))
                        }
                    }
                    catch {
                        print("Something went wrong")
                    }
                    successCallback(config)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    
    //"https://ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=" + uuid;
   
    
    
    static func sendFCMToken(_ delegate: HttpRequestDelegate?, strToken : String,  success successCallback: @escaping SuccessCompletionHandler)
    {
        //https:///api/iot.php?view=token&username=demo&token=esEETMYXPxk:APA91bH7TMtcrfO7MmGYArkPYNEIRXpwFFfwwYB2F52XjyZnj2XIi1ANWevZ4579ITZ9Dp1LG9oQdj_-IpocyjpzkAsUlN102YEDNlTKvdX-aqcyhHFmt4JnzkjPMnkI_5L9jV_u9AO2BNFwzCYtTvKPYefKrqtAmQ&system=android&system_type=android&country=IN&language=en&phone_id=351897081138731
        let udid = UIDevice.current.identifierForVendor?.uuidString
        let url = "https://ping.ibeyonde.com/api/iot.php?view=token&username=\(Users.getUserName())&token=\(strToken)&system=iOS&system_type=iOS&country=IN&language=en&phone_id=\(udid ?? "123456")"
        
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }
        let loginString = String(format: "%@:%@", Users.getUserName(), Users.getPassword())
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("ping.ibeyonde.com", forHTTPHeaderField: "Host")
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onError()
                } else if
                    let data: Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    //send this block to required place
                    let respstr = String(decoding: data, as: UTF8.self)
                    print("Response " + respstr)
                    successCallback(respstr)
                }
                else {
                    print("Unknown error")
                    delegate?.onError()
                }
        }
        dataTask?.resume()
    }
    

    func onError() {
        DispatchQueue.main.async() {
            print("Error: url request faile")
        }
    }

}

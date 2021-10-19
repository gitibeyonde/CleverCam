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
                        print(jsonObjects)
                        for jsonObject in jsonObjects {
                            historyList.append(History(url: jsonObject[0], time: jsonObject[1]))
                            print( jsonObject[1])
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
        
        let device:Device = ApiContext.shared.getDevice(uuid: LiveViewController.uuid)
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
                            print("Device list set")
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
                    
                    print("Running")
                    semaphore.signal()
            }
            dataTask?.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            print("Resume")
        } ///if device.uuid == ""
        
        print("Have device ", device.deviceip)
        
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

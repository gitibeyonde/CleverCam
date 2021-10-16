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

public struct HttpRequest {
    
    public typealias SuccessCompletionHandler = (_ response: String) -> Void
    
    public typealias JsonSuccessCompletionHandler = (_ response: Data) -> Void
    
    public typealias AlertSuccessCompletionHandler = (_ response: Array<Alert>) -> Void
    
    static func get(_ delegate: HttpRequestDelegate?, url: String,
                    success successCallback: @escaping SuccessCompletionHandler
    ) {
        
      //We need to be sure that we have an usable url to make the request,
      //if not lets call the delegate to manage the error
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            delegate?.onError()
            return
        }

        var request = URLRequest(url: usableUrl)
        request.httpMethod = "GET"
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
                    success successCallback: @escaping JsonSuccessCompletionHandler
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
                    //send this block to required place
                    successCallback(data)
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
    
    
    func convertStringToDictionary(_ text: String) -> [String:AnyObject] {
        if let data = text.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                return (json as AnyObject) as! [String : AnyObject]
            } catch {
                print("Something went wrong")
            }
        }
        return ["":"" as AnyObject]
    }
}

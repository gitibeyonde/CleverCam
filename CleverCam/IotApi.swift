//
//  IotApi.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import UIKit

public enum ParsingConstant : Int
{
    case Login
    case Registration
    case LiveHD
}

protocol IotApi_Delegate {
    func xlmParsingFinishedWith(_home: String,_reachRank:String)
}

class IotApi: NSObject {
    var callback : IotApi_Delegate!
    let SERVER_ERROR = "Server not responding.\nPlease try after some time."

    public func loginWithUsername(username:String,password:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://\(username):\(password)@ping.ibeyonde.com/api/iot.php?view=login"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["code"] as? NSNumber,let message = obj.parsedDataDict["message"] as? String
                {
                    if code == 200
                    {
                        successMessage(message)
                        if iBeyondeUserDefaults.getFCMtoken() != ""
                        {
                            self.sendFCMTokentoServer(strToken: iBeyondeUserDefaults.getFCMtoken(), successMessage: { (response) in
                                print("FCM token sent successfully to server with error.")
                                
                            }) { (error) in
                                print("Fail to send FCM token server with error : \(error as! String)")
                            }
                        }

                        iBeyondeUserDefaults.setUserName(object: username)
                        iBeyondeUserDefaults.setPassword(object: password)
                        iBeyondeUserDefaults.setLoginStatus(object: "true")
                    }
                    else
                    {
                        failureMessage(message)
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }

            }
        }
    }
    public func registerWithUsername(username:String,email:String,password:String,phone:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        var params = [String:AnyObject]()
        params["user_name"] = username as AnyObject
        params["user_email"] = email as AnyObject
        params["user_password_new"] = password as AnyObject
        params["user_password_repeat"] = password as AnyObject
        params["user_phone"] = phone as AnyObject

        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Registration.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "https:///api/iot.php?view=register"//&user_name=\(username)&user_email=\(email)&user_password_new=\(password)&user_password_repeat=\(password)&user_phone=\(phone)
        obj.params = params
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["code"] as? NSNumber,let message = obj.parsedDataDict["message"] as? String
                {
                    if code == 205
                    {
                        successMessage(message)
                    }
                    else
                    {
                        failureMessage(message)
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getDeviceList(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
//        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@/api/iot.php?view=devicelist"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=devicelist"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                {
                    var arrDevices = [DeviceListBO]()
                    for dict in data
                    {
                        let bo = DeviceListBO()
                        if let code = dict["uuid"] as? String
                        {
                           bo.uuid = code
                        }
                        if let device_name = dict["device_name"] as? String
                        {
                            bo.device_name = device_name
                        }
                        if let setting = dict["setting"] as? String
                        {
                            bo.setting = setting
                            var dict = [String:AnyObject]()
                                if let data = bo.setting.data(using: .utf8) {
                                    do {
                                        dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
                                        if let videoMode = dict["video_mode"] as? String
                                        {
                                            bo.video_mode = videoMode
                                        }
                                        if let sip_reg = dict["sip_reg"] as? String
                                        {
                                            bo.sip_reg = sip_reg
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                        }
                        arrDevices.append(bo)
                    }
                    successMessage(arrDevices)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    
    public func getImagesForList(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
//        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=\(strID)"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=\(strID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String]]
                {
                    var arrImages = [listImageBO]()
                    for item in data
                    {
                        let bo = listImageBO()
                        bo.strImage = item[0]
                        bo.strTime = item[1]
                        arrImages.append(bo)
                    }
                    successMessage(arrImages)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func closeStreamWithid(sID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        //        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@ping.ibeyonde.com/api/iot.php?view=lastalerts&uuid=\(strID)"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=liveclose&uuid=4d6711e1&sid=\(sID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String]]
                {
                    successMessage("Success")
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }

    public func getLatestImageForList(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
//        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@ping.ibeyonde.com/api/iot.php?view=lastalert&uuid=\(strID)"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=lastalert&uuid=\(strID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [String]
                {
                    if data.count > 1
                    {
                        let bo = listImageBO()
                        bo.strImage = data[0]
                        bo.strTime = data[1]
                        successMessage(bo)
                    }
                    else
                    {
                        failureMessage("No Data Found")
                    }
                    
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getHistoryWith(strID : String,strDate : String,strTime : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
//        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@ping.ibeyonde.com/api/iot.php?view=history&uuid=\(strID)&date=\(strDate)&time=\(strTime)"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=history&uuid=\(strID)&date=\(strDate)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                {
                    var arrImages = [listImageBO]()
                    for dict in data
                    {
                        let bo = listImageBO()
                        if let datetime = dict["datetime"] as? String
                        {
                            bo.strTime = datetime
                        }
                        if let url = dict["url"] as? String
                        {
                            bo.strImage = url
                        }
                        arrImages.append(bo)
                    }
                    successMessage(arrImages)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getLiveHDForList(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.LiveHD.rawValue
        obj.MethodNamee = "GET"
//        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@ping.ibeyonde.com/api/iot.php?view=live&uuid=\(strID)&quality=MINI"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=live&uuid=\(strID)&quality=MINI"
      obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? String
                {
                    successMessage(data)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getLiveForList(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.LiveHD.rawValue
        obj.MethodNamee = "GET"
//        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@ping.ibeyonde.com/api/iot.php?view=live&uuid=\(strID)&quality=SIMI"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=live&uuid=\(strID)&quality=SIMI"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? String
                {
                    successMessage(data)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func streamWith(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //https://demo:demo123@ping.ibeyonde.com/api/iot.php?view=mp4stream&uuid=5128830a
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.LiveHD.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=mp4stream&uuid=\(strID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? String
                {
                    successMessage(data)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getIndexWith(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //https://demo:demo123@ping.ibeyonde.com/api/iot.php?view=mp4index&uuid=5128830a
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.LiveHD.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=mp4index&uuid=\(strID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let str = obj.parsedDataDict["data"] as? String
                {
                    var dict = [String:AnyObject]()
                    do {
                        if let data = str.data(using: .utf8) {
                            do {
                                dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
                                if let index = dict["index"] as? String
                                {
                                    var arrTemp = [IndexBO]()
                                    
                                    for str in index.components(separatedBy: ":")
                                    {
                                        let bo = IndexBO()
                                        bo.index = str.components(separatedBy: "-")[0]
                                        bo.value = str.components(separatedBy: "-")[1]
                                        arrTemp.append(bo)
                                    }
                                    successMessage(arrTemp)
                                }
                                else
                                {
                                    failureMessage("No Data")
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        else
                        {
                            failureMessage("No Data")
                        }
                    } catch {
                        print("Something went wrong")
                    }

                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func sendFCMTokentoServer(strToken : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //https:///api/iot.php?view=token&username=demo&token=esEETMYXPxk:APA91bH7TMtcrfO7MmGYArkPYNEIRXpwFFfwwYB2F52XjyZnj2XIi1ANWevZ4579ITZ9Dp1LG9oQdj_-IpocyjpzkAsUlN102YEDNlTKvdX-aqcyhHFmt4JnzkjPMnkI_5L9jV_u9AO2BNFwzCYtTvKPYefKrqtAmQ&system=android&system_type=android&country=IN&language=en&phone_id=351897081138731
        let udid = UIDevice.current.identifierForVendor?.uuidString
        
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.LiveHD.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://ping.ibeyonde.com/api/iot.php?view=token&username=\(iBeyondeUserDefaults.getUserName())&token=\(strToken)&system=iOS&system_type=iOS&country=IN&language=en&phone_id=\(udid ?? "123456")"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let str = obj.parsedDataDict["data"] as? String
                {
                    let dict = self.convertStringToDictionary(str)
                    if let code = dict["code"] as? NSNumber,let message = dict["message"] as? String
                    {
                        if code.intValue == 206
                        {
                            successMessage(message)
                        }
                        else
                        {
                            failureMessage(message)
                        }
                    }
                    else
                    {
                        failureMessage(self.SERVER_ERROR)
                    }

                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
            }
        }
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



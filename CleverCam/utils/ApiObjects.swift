//
//  DeviceListJson.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 15/10/21.
//

import Foundation



public struct Device: Codable {
    var uuid: String
    var user_name: String
    var device_name: String
    var capabilities: String
    var version: String
    var deviceip: String
    var created: String
    
    init(){
        uuid=""
        user_name=""
        device_name=""
        capabilities=""
        version=""
        deviceip=""
        created=""
    }
}


/**
 
 [["https:\/\/s3-us-west-2.amazonaws.c441d051905d6f13f4c202","15\/10\/2021 - 13:10:13"],["https:\/\/s3-us-
 */
public struct DeviceAlerts:Codable {
    var uuid: String
    var alertlist: Array<Alert>
    
    init(){
        uuid=""
        alertlist=Array<Alert>()
    }
}
public struct Alert:Codable {
    var url: String
    var time: String
    
    init(){
        url=""
        time=""
    }
    init(url: String, time: String){
        self.url = url
        self.time = time
    }
}


public struct DeviceHistory:Codable {
   var uuid: String
   var historylist: Array<History>
   
   init(){
        uuid=""
        historylist=Array<History>()
   }
}

public struct History:Codable {
   var url: String
   var time: String
   
   init(){
       url=""
       time=""
   }
   init(url: String, time: String){
       self.url = url
       self.time = time
   }
}


public struct CCNotification:Codable {
    var uuid: String
    var id: String
    var created: String
    var image: String
    var type: String
    
    init(){
        uuid=""
        id=""
        created=""
        image=""
        type=""
    }
    
    init(uuid: String, id: String, created: String, image: String, type: String){
        self.uuid=uuid
        self.id=id
        self.created=created
        self.image=image
        self.type=type
    }
}


public struct BellHistory:Codable {
   var url: String
   var datetime: String
   
   init(){
        url=""
        datetime=""
   }
   init(url: String, time: String){
       self.url = url
       self.datetime = time
   }
}

/**
 {"pixformat":3,"framesize":5,"quality":10,"brightness":0,"contrast":0,"saturation":0,"sharpness":0,"special_effect":0,"wb_mode":0,"awb":1,"awb_gain":1,"aec":1,"aec2":0,"ae_level":0,"aec_value":204,"agc":1,"agc_gain":0,"gainceiling":0,"bpc":0,"wpc":1,"raw_gma":1,"lenc":1,"vflip":1,"hmirror":0,"dcw":1,"colorbar":0,"history": "true","cloud": "true","timezone": "Asia/Calcutta","name": "SmartCam","version": "5"}
 */
public struct CameraConfig:Codable {
    var pixformat: Int
    var framesize: Int
    var quality: Int
    var brightness: Int
    var contrast: Int
    var saturation: Int
    var sharpness: Int
    var special_effect: Int
    var wb_mode: Int
    var awb: Int
    var awb_gain: Int
    var aec: Int
    var aec2: Int
    var ae_level: Int
    var aec_value: Int
    var agc: Int
    var agc_gain: Int
    var gainceiling: Int
    var bpc: Int
    var wpc: Int
    var raw_gma: Int
    var lenc: Int
    var vflip: Int
    var hmirror: Int
    var dcw: Int
    var colorbar: Int
    var history: String
    var cloud: String
    var timezone: String
    var name: String
    var version: String
 
    init(){
        pixformat=0
        framesize=0
        quality=0
        brightness=0
        contrast=0
        saturation=0
        sharpness=0
        special_effect=0
        wb_mode=0
        awb=0
        awb_gain=0
        aec=0
        aec2=0
        ae_level=0
        aec_value=0
        agc=0
        agc_gain=0
        gainceiling=0
        bpc=0
        wpc=0
        raw_gma=0
        lenc=0
        vflip=0
        hmirror=0
        dcw=0
        colorbar=0
        history=""
        cloud=""
        timezone=""
        name="SmartCam"
        version=""
    }
}

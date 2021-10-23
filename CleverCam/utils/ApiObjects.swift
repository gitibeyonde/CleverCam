//
//  DeviceListJson.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 15/10/21.
//

import Foundation

/**

[{"uuid":"4d6711e1","user_name":"demo","device_name":"LakeView","type":"NORMAL","profile":"basic","profile_id":"-1","box_name":"default","timezone":"Asia\/Calcutta","capabilities":"CAMERA,MOTION,TEMPERATURE\nrotation","version":"1.2.1","setting":"{ \"version\":\"1.2.1\",  \"time\":\"2021\/10\/03-09:51:51\", \"timezone\":\"Asia\/Calcutta\", \"uptime\":\" 09:51:51 up 2 days, 16:55,  0 users,  load average: 0.06, 0.08, 0.12\", \"camname\":\"LakeView\", \"hostname\":\"LakeView\", \"httpport\":\"80\", \"sip_reg\":\"false\", \"hourly_snapshot\":\"true\", \"zoom\":\"[0, 0, 1, 1] \", \"rotate\":\"90\", \"vertical_flip\":\"\", \"horizontal_flip\":\"\", \"brightness\":\"\", \"grid_detect\":\"\", \"face_detect\":\"\", \"snap_quality\":\"4\", \"motion_quality\":\"1\", \"face_min\":\"\", \"motion_tolerance\":\"5000\", \"capturedelta\":\"\", \"video_mode\": \"0\", \"public_key\":\"Not Instrumented\", \"git_commit\":\"375eecdfd05bda687a0ef67ffd85850cc0f30c49: maintain a map of neighbours: TODO get a map on demand\" }","email_alerts":"0","deviceip":"192.168.100.34","visibleip":"1.186.104.17","port":"455","created":"2021-10-01 01:31:47","updated":"2021-10-15T09:13:19+00:00","token":"ghgIWofqjA","errors":[],"messages":[],"nat":"0","expiry":"1634781309","ltoken":"JcpyHMUeDX"},
 
 {"uuid":"3105613C","user_name":"demo","device_name":"MainDoor","type":"NORMAL","profile":"basic","profile_id":"-1","box_name":"default","timezone":"Asia\/Calcutta","capabilities":"CAMERA,MOTON","version":"3","setting":"","email_alerts":"0","deviceip":"192.168.100.3","visibleip":"1.186.104.17","port":null,"created":"2021-10-04 05:04:58","updated":"2021-10-15T09:13:19+00:00","token":"IvXLcuTiXb","errors":[],"messages":[],"nat":"0","expiry":"1635053898","ltoken":"pdhbaNtKDg"}]


**/


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


public struct Notification:Codable {
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

//
//  User.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import UIKit

let isRemember = "isRemember"
let UserId = "UserId"
let ProfPic = "ProfilePic"
let FirstName = "FirstName"
let LastName = "LastName"
let Role = "Role"
let UserName = "UserName"
let Password = "Password"
let Auth = "Auth"
let Publishid = "Publishid"
let TeamId = "TeamId"
let CatId = "CatId"
let PUBLISHLASTSYNCTIME = "PUBLISHLASTSYNCTIME"
let DRAFTLASTSYNCTIME = "DRAFTLASTSYNCTIME"
let ONLINELASTSYNCTIME = "ONLINELASTSYNCTIME"
let NAME = "name"
let Published = "Published"
let defaultMotion = "DefaultMotion"
let FCM = "FCM"
let Status = "Status"

class Users: NSObject {
    
    class func setLoginStatus (object : String)
    {
        UserDefaults.standard.set(object, forKey: isRemember)
        UserDefaults.standard.synchronize()
    }
    
    class func getLoginStatus () -> String
    {
        if UserDefaults.standard.object(forKey: isRemember) as? String == nil
        {
            return "false"
        }
        else
        {
            return UserDefaults.standard.object(forKey: isRemember) as! String
        
        }
    }
    class func setTeamId (object : String)
    {
        UserDefaults.standard.set(object, forKey: TeamId)
        UserDefaults.standard.synchronize()
    }
    
    class func getTeamId () -> String
    {
        if UserDefaults.standard.object(forKey: TeamId) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: TeamId) as! String
            
        }
    }

    class func setUserId (object : String)
    {
        UserDefaults.standard.set(object, forKey: UserId)
        UserDefaults.standard.synchronize()
    }
    
    class func getUserId () -> String
    {
        if UserDefaults.standard.object(forKey: UserId) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: UserId) as! String
            
        }
    }
    class func setPublishId (object : String)
    {
        UserDefaults.standard.set(object, forKey: Publishid)
        UserDefaults.standard.synchronize()
    }
    
    class func getPublishId () -> String
    {
        if UserDefaults.standard.object(forKey: Publishid) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: Publishid) as! String
            
        }
    }
    class func setPublished (object : String)
    {
        UserDefaults.standard.set(object, forKey: Published)
        UserDefaults.standard.synchronize()
    }
    
    class func getPublished () -> String
    {
        if UserDefaults.standard.object(forKey: Published) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: Published) as! String
            
        }
    }
    class func setUserName (object : String)
    {
        UserDefaults.standard.set(object, forKey: UserName)
        UserDefaults.standard.synchronize()
    }
    
    class func getUserName () -> String
    {
        if UserDefaults.standard.object(forKey: UserName) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: UserName) as! String
            
        }
    }
    class func setStatus (object : String)
    {
        UserDefaults.standard.set(object, forKey: Status)
        UserDefaults.standard.synchronize()
    }
   class func getStatus () -> String
    {
        if UserDefaults.standard.object(forKey: Status) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: Status) as! String
            
        }
    }

    class func setDefaultMotion (object : String)
    {
        UserDefaults.standard.set(object, forKey: defaultMotion)
        UserDefaults.standard.synchronize()
    }
    
    class func getDefaultMotion () -> String
    {
        if UserDefaults.standard.object(forKey: defaultMotion) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: defaultMotion) as! String
            
        }
    }
    
    class func setCatID(object : String)
    {
        UserDefaults.standard.set(object, forKey: CatId)
        UserDefaults.standard.synchronize()
    }
    class func getCatID () -> String
    {
        if UserDefaults.standard.object(forKey: CatId) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: CatId) as! String
            
        }
    }
    
    class func setPassword (object : String)
    {
        UserDefaults.standard.set(object, forKey: Password)
        UserDefaults.standard.synchronize()
    }
    
    
    
    class func getPassword () -> String
    {
        if UserDefaults.standard.object(forKey: Password) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: Password) as! String
            
        }
    }
    
    class func setProfPic (object : String)
    {
        UserDefaults.standard.set(object, forKey: ProfPic)
        UserDefaults.standard.synchronize()
    }
    
    class func getProfPic () -> String
    {
        if UserDefaults.standard.object(forKey: ProfPic) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: ProfPic) as! String
            
        }
    }
    class func setFirstName (object : String)
    {
        UserDefaults.standard.set(object, forKey: FirstName)
        UserDefaults.standard.synchronize()
    }
    
    class func getFirstName () -> String
    {
        if UserDefaults.standard.object(forKey: FirstName) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: FirstName) as! String
            
        }
    }
    class func setLastName (object : String)
    {
        UserDefaults.standard.set(object, forKey: LastName)
        UserDefaults.standard.synchronize()
    }
    
    class func getLastName () -> String
    {
        if UserDefaults.standard.object(forKey: LastName) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: LastName) as! String
            
        }
    }
    class func setRole (object : String)
    {
        UserDefaults.standard.set(object, forKey: Role)
        UserDefaults.standard.synchronize()
    }
    
    class func getRole () -> String
    {
        if UserDefaults.standard.object(forKey: Role) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: Role) as! String
            
        }
    }
    
    class func getPublishLastSyncTime() -> String
    {
        if UserDefaults.standard.object(forKey: PUBLISHLASTSYNCTIME) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: PUBLISHLASTSYNCTIME) as! String
        }
    }
    
    class func setPublishLastSyncTime()
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        UserDefaults.standard.set(dateString, forKey: PUBLISHLASTSYNCTIME)
        UserDefaults.standard.synchronize()
    }

    class func getBlogLastSyncTime() -> String
    {
        if UserDefaults.standard.object(forKey: DRAFTLASTSYNCTIME) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: DRAFTLASTSYNCTIME) as! String
        }
    }
    
    class func setBlogLastSyncTime()
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tempCalendar = Calendar.current
        let alteredHourDate = tempCalendar.date(byAdding: .hour, value: -5, to: date)
        let alteredMinuteDate = tempCalendar.date(byAdding: .minute, value: -30, to: alteredHourDate!)
        let dateString = dateFormatter.string(from: alteredMinuteDate!)
        UserDefaults.standard.set(dateString, forKey: DRAFTLASTSYNCTIME)
        UserDefaults.standard.synchronize()
    }

    class func getOnlineLastSyncTime() -> String
    {
        if UserDefaults.standard.object(forKey: ONLINELASTSYNCTIME) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: ONLINELASTSYNCTIME) as! String
        }
    }
    
    class func setOnlineLastSyncTime()
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        UserDefaults.standard.set(dateString, forKey: ONLINELASTSYNCTIME)
        UserDefaults.standard.synchronize()
    }

    class func setAuth (object : String)
    {
        UserDefaults.standard.set(object, forKey: Auth)
        UserDefaults.standard.synchronize()
    }
    
    class func getAuth () -> String
    {
        if UserDefaults.standard.object(forKey: Auth) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: Auth) as! String
            
        }
    }
    class func setProfileName (object : String)
    {
        UserDefaults.standard.set(object, forKey: NAME)
        UserDefaults.standard.synchronize()
    }
    
    class func getProfileName () -> String
    {
        if UserDefaults.standard.object(forKey: NAME) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: NAME) as! String
            
        }
    }
    class func getFCMtoken () -> String
    {
        if UserDefaults.standard.object(forKey: FCM) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: FCM) as! String
            
        }
    }
    class func setFCMtoken (object : String)
    {
        UserDefaults.standard.set(object, forKey: FCM)
        UserDefaults.standard.synchronize()
    }

}

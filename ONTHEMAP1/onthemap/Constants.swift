//
//  Constants.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٣ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import Foundation

struct Contstants {
    
    struct URLlink {
        static let Session = "https://www.udacity.com/api/session"
        static let userdata = "https://www.udacity.com/api/users/"
        static let Studentlocations = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100?order=-updatedAt"
        static let Postlocation = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let Signup = "https://www.udacity.com/account/auth#!/signup"
        
    }
    struct login {
        static var username = ""
        static var password = ""

    }
    
    struct ResponseKey {
        static let Userid = "key"
        static let user = "user"
        static let session = "session"
        static let id = "id"
        static let account = "account"
        static let key = "key"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let results = "results"
    }
    
   
    
    struct JSONKEY {
        static var objectId = "objectid"
        static var uinquekey = "uniquekey"
        static var firstName = "firstName"
        static var lastName = "lastName"
        static var mapSting = "mapString"
        static var mediaURL = "mediaURL"
        static var createdAt = "createdAt"
        static var updatedAt = "updatedAt"
        static var latitude  = "latitude"
        static var longitude = "longitude"
              
    }
}

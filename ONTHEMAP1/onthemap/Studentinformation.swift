//
//  StudentinformationConsttant.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٧ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import Foundation

struct Studentinformation {
    
    var firstname : String = ""
    var lastname : String = ""
    var mapstring: String = ""
    var mediaurl : String = ""
    var createdAt : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var objectId : String = ""
    var uniqueKey : String = ""
    var updatedAt : String = ""
    
    init(dicionary: [String:AnyObject]) {
        
        if let first = dicionary[Contstants.JSONKEY.firstName] as? String {
            firstname = first
        }
        if let last = dicionary[Contstants.JSONKEY.lastName] as? String {
            lastname = last
        }
        if let mapS = dicionary[Contstants.JSONKEY.mapSting] as? String {
            mapstring = mapS
        }
        if let mediaU = dicionary[Contstants.JSONKEY.mediaURL] as? String{
            mediaurl = mediaU
        }
        if let createdat = dicionary[Contstants.JSONKEY.createdAt] as? String {
            createdAt = createdat
        }
        if let latitud = dicionary[Contstants.JSONKEY.latitude] as? Double {
            latitude = latitud
            
        }
        if let long = dicionary[Contstants.JSONKEY.longitude] as? Double {
            longitude = long
        }
        if let objectid = dicionary[Contstants.JSONKEY.objectId] as? String {
            objectId = objectid
        }
        if let uniqueK = dicionary[Contstants.JSONKEY.uinquekey] as? String {
            uniqueKey = uniqueK
        }
        if let updatedat = dicionary[Contstants.JSONKEY.updatedAt] as? String{
            updatedAt = updatedat
        }
        
    }
    
    static func studentinformationResualt(_ results: [[String:AnyObject]]) ->[Studentinformation]{
        
        var information = [Studentinformation]()
        
        for result in results {
            
            information.append(Studentinformation(dicionary: result))
        }
        
        return information
    }
    
}

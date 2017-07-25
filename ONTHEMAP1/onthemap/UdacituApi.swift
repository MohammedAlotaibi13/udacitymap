//
//  UdacituApi.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٣ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import Foundation

class UdacituApi: NSObject{
    
    
    func postingSession(_ completionhandlerforpostingsession: @escaping (_ result: AnyObject? , _ error: NSError?)->Void) ->URLSessionDataTask {
        
        let request = NSMutableURLRequest(url:  URL(string: Contstants.URLlink.Session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody =  "{\"udacity\": {\"username\": \"\(Contstants.login.username)\", \"password\": \"\(Contstants.login.password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            
            guard (error == nil) else{
                print("There was an error with Your request \(error)")
                completionhandlerforpostingsession(nil, error! as NSError)
                return
            }
            guard let statecode = (response as? HTTPURLResponse)?.statusCode, statecode >= 200 && statecode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionhandlerforpostingsession(nil, error as? NSError)
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                completionhandlerforpostingsession(nil, error! as NSError)
                return
            }
            
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertdata(newData, completionhandlerforconvertdata: completionhandlerforpostingsession )
        }
        task.resume()
        return task
    }
    
    
    func getStudentLocations(completionhandlerforgetStudentlocations: @escaping (_ result: AnyObject?,_ error: NSError? )-> Void){
        
        let request = NSMutableURLRequest(url: URL(string: Contstants.URLlink.Postlocation)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4Y", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                print("failed to your request")
                completionhandlerforgetStudentlocations( nil, error! as NSError)
            }
            
            
            /*  guard let statecode = (response as? HTTPURLResponse)?.statusCode, statecode >= 200 && statecode <= 299 else {
             print("Your status code does not conform to 2xx.")
             completionhandlerforgetStudentlocations( nil, error! as NSError)
             return
             }*/
            guard let data = data else {
                print("There is no data returned")
                completionhandlerforgetStudentlocations( nil, error! as NSError)
                return
            }
            let parseResualt: AnyObject!
            do{
                parseResualt = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                print("Couldn't parse data into json ")
                completionhandlerforgetStudentlocations( nil, error as NSError)
            }
            
            if let errorString = parseResualt["error"] as? String {
                print(errorString)
                
                let errorStr = "Invalid login credentials"
                let error = NSError(domain: errorStr, code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
                
                completionhandlerforgetStudentlocations(nil, error as NSError)
                return
            }
            
            
            completionhandlerforgetStudentlocations(parseResualt, nil)
            
        }
        task.resume()
    }
    
    func deletingSession(_ completionhandlerfordeletingsession: @escaping (_ resualt: AnyObject?,_ error: NSError?)->Void)->URLSessionTask {
        
        let request = NSMutableURLRequest(url: URL(string: Contstants.URLlink.Session)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN"  { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("check your request\(error))")
                completionhandlerfordeletingsession(nil, error! as NSError)
            }
            guard let statecode = (response as? HTTPURLResponse)?.statusCode, statecode >= 200 && statecode <= 299 else {
                print("Your status code does not conform to 2xx.")
                completionhandlerfordeletingsession(nil, error! as NSError)
                return
            }
            
            guard let data = data else {
                print("The request returned no data")
                completionhandlerfordeletingsession(nil, error! as NSError)
                return
            }
            
            
            
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            self.convertdata(newData, completionhandlerforconvertdata: completionhandlerfordeletingsession)
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        task.resume()
        return task
        
    }
    
    func postStudentLocation(uniquekey:String,  mapString:String, mediaURL: String, latitude: Double , longitude: Double,_ comletionhandler: @escaping (_ success: Bool ,_ error: NSError?)->Void )->URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: Contstants.URLlink.Studentlocations)!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("pplication/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniquekey)\", \"firstName\": \"\(StudentData.firstName)\", \"lastName\": \"\(StudentData.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                print("Something happen with your request \(error)")
                comletionhandler(false, error! as NSError)
                
            }
            
            /* guard let statecode = (response as? HTTPURLResponse)?.statusCode, statecode >= 200 && statecode <= 299 else {
             print("Your status code does not conform to 2xx.")
             comletionhandler(false, error! as NSError)
             return
             } */
            
            guard let data = data else {
                print("There is no data")
                comletionhandler(false, error! as NSError)
                return
            }
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            
            var parseResualt: [String:AnyObject]
            
            do{
                
                parseResualt = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                
            }catch {
                
                print("Couldn't parse the data\(data)")
                comletionhandler(false, error as NSError)
                return
            }
            
            if let errorString = parseResualt["error"] as? String {
                print(errorString)
                
                let errorStr = "Invalid login credentials"
                let error = NSError(domain: errorStr, code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
                
                comletionhandler(false, error as NSError)
                return
            }
            
            
            
            
            guard let objecId = parseResualt["objectId"] as? String else {
                print("There is no objecid")
                comletionhandler(false, error! as NSError)
                return
            }
            
            guard let createdAt = parseResualt["createdAt"] as? String else {
                print("No createdAt")
                comletionhandler(false, error! as NSError)
                return
            }
            
            
            StudentData.objectId = objecId
            StudentData.createdAt = createdAt
            print("Your objecId is \(objecId) and createdAt \(createdAt) ")
            comletionhandler(true, nil)
            
        }
        
        task.resume()
        return task
    }
    
    
    func updateStudentLocation(uniquekey: String , mapString: String , mediaURL:String , latitude: Double , longitude: Double,_ completionhandler: @escaping (_ success: Bool,_ error: NSError?)->Void ){
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/\(StudentData.objectId)")!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniquekey)\", \"firstName\": \"\(StudentData.firstName)\", \"lastName\": \"\(StudentData.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            if error != nil {
                print("Something happen with your request \(error)")
                completionhandler(false, error! as NSError)
            }
            
            /*  guard let statecode = (response as? HTTPURLResponse)?.statusCode, statecode >= 200 && statecode <= 299 else {
             print("Your status code does not conform to 2xx.")
             completionhandler(false,error! as NSError)
             return
             }*/
            
            guard let data = data else {
                print("There is no data")
                completionhandler(false, error! as NSError)
                return
            }
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            
            let parseResult: [String:AnyObject]
            do{
                parseResult = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Couldn't parse data\(data)")
                completionhandler(false, error as NSError)
                return
            }
            
            guard let updatedAt = parseResult["updatedAt"] as? String else {
                print("There is no updateAt")
                return
            }
            if let errorString = parseResult["error"] as? String {
                print(errorString)
                
                let errorStr = "Invalid login credentials"
                let error = NSError(domain: errorStr, code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
                
                completionhandler(false, error as NSError)
                return
            }
            
            
            StudentData.updatedAt = updatedAt
            completionhandler(true, nil)
        }
        
        task.resume()
    }
    
    
    func getSingleStudent(_ userid:String,_ completiohandler: @escaping (_ result: AnyObject? ,_ error: NSError?)->Void )->URLSessionDataTask {
        let url = Contstants.URLlink.userdata + userid
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("error :\(error) ")
                completiohandler(nil, error as NSError?)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completiohandler(nil, error as NSError?)
                print("\tYour request returned a status code other than 2xx!: \(response!)")
                return
            }
            guard let data = data else {
                print("\tNo data was returned by the request!")
                completiohandler(nil, error as NSError?)
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            
            self.convertdata(newData, completionhandlerforconvertdata: completiohandler)
            
        }
        
        task.resume()
        return task
        
    }
    
    
    func convertdata (_ data: Data ,  completionhandlerforconvertdata: @escaping (_ result: AnyObject? ,_ error: NSError?)->Void) {
        
        var parseresult: AnyObject! = nil
        do{
            parseresult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
        } catch {
            let userinfo = [NSLocalizedDescriptionKey: "Could not parse data \(data)"]
            completionhandlerforconvertdata(nil, NSError(domain: "convertdata", code: 1, userInfo: userinfo))
        }
        
        if let errorString = parseresult["error"] as? String {
            print(errorString)
            
            let errorStr = "Invalid login credentials"
            let error = NSError(domain: errorStr, code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
            
            completionhandlerforconvertdata(nil, error as NSError)
            return
        }
        
        
        completionhandlerforconvertdata(parseresult, nil)
    }
    
    
    class func sharedinstance()-> UdacituApi {
        struct singlton {
            static var sharedinstance = UdacituApi()
        }
        return singlton.sharedinstance
    }
    
    
    
}

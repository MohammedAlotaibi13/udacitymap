//
//  UdaicityConvience.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٣ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import Foundation
import UIKit

extension  UdacituApi {
    
    func authenticateWithViewController(_ hostViewController: UIViewController,_ completionhanlerForAuth: @escaping (_ success: Bool ,_ error: String? )->Void ){
        
        self.getUserId { (success, error) in
            if let error = error {
                
                completionhanlerForAuth(success, error)
            } else {
                completionhanlerForAuth(success, error)
            }
        }
        
    }
    func getUserId(_ completionhandlerforgetuserid: @escaping (_ success: Bool ,_ error: String? )->Void ){
        
        let _ = postingSession() { (result, error) in
            
            if let error = error {
                print(error)
                completionhandlerforgetuserid(false, "No internet connection")
            } else {
                guard let session = result?[Contstants.ResponseKey.session] as? [String:AnyObject] else {
                    print("There is no session id")
                    completionhandlerforgetuserid(false, "Your Email or Password isn't correct")
                    return
                }
                guard let sessionid = session[Contstants.ResponseKey.id] as? String else {
                    print("No session id")
                    completionhandlerforgetuserid(false, "Failed to get session id")
                    return
                }
                guard let account = result?[Contstants.ResponseKey.account] as? [String:AnyObject] else {
                    print("No account found")
                    completionhandlerforgetuserid(false, "Failed to get Your account")
                    return
                }
                guard let key = account[Contstants.ResponseKey.key] as? String else {
                    print("No key found")
                    completionhandlerforgetuserid(false, "Failed to get Your account key")
                    return
                }
                
                StudentData.userId = key
                print("Your user id is \(key)")
                
                self.getUserData(){ (success, error) in
                    if success {
                        print("get data successfully")
                    } else {
                        print("Failed to get user data")
                    }
                    completionhandlerforgetuserid(true, "success")
                }
                completionhandlerforgetuserid(true, "login successfully")
            }
            
        }
    }
    
    func getUserData(_ comletionhandlerforget:  @escaping (_ success: Bool,_ error: String?)->Void ){
        let _ = getSingleStudent(StudentData.userId) { (resultData, error) in
            if let  error  = error {
                print(error)
                comletionhandlerforget(false, "There is problem with the Server")
                
            } else {
                guard let user = resultData?[Contstants.ResponseKey.user] as? [String:AnyObject] else {
                    print("Couldn't find key ")
                    comletionhandlerforget(false, "Failed to get data")
                    return
                }
                guard let firstname = user[Contstants.ResponseKey.firstName] as? String else {
                    print("failed to get firstname")
                    comletionhandlerforget(false, "Failed to get firstName")
                    return
                }
                guard let lastName = user[Contstants.ResponseKey.lastName] as? String else {
                    print("failed to get lastname")
                    comletionhandlerforget(false, "Failed to get lastName")
                    return
                }
                
                StudentData.firstName = firstname
                StudentData.lastName = lastName
                print("Your first Name : \(firstname) lastname : \(lastName)")
                comletionhandlerforget(true, nil)
            }
            
        }
        
        
        
    }
    
    func getStudensData(_ completionhandlerforget: @escaping (_ result:[Studentinformation]?,_ error: String?)->Void){
        
        
        self.getStudentLocations { (resultdata, error) in
            if let error = error {
                completionhandlerforget(nil, "Failed to download Students location")
                
            } else {
                if let location = resultdata?[Contstants.ResponseKey.results] as? [[String : AnyObject]]  {
                    StudentArray.sharedInstance.myArray = [Studentinformation]()
                    
                    for studentresult in location {
                        StudentArray.sharedInstance.myArray.append(Studentinformation(dicionary: studentresult))
                        
                    }
                    completionhandlerforget(StudentArray.sharedInstance.myArray, nil)
                } else {
                    completionhandlerforget(nil, "Failed to download Student data")
                }
            }
        }
        
    }
    
    func postNewStudent(uniqekey:String ,mapString: String , mediaURL: String , latitude: Double , longitude: Double,_ comletionhandler: @escaping (_ success: Bool ,_ error: String?)->Void ) {
        
        self.postStudentLocation(uniquekey: uniqekey, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (success, error) in
            if let error = error {
                comletionhandler(false, "Failed to Post Your location")
                
            } else {
                comletionhandler(true, nil)
            }
        }
        
        
    }
    
    func updateNewStudent(uniquekey: String , mapString: String , mediaURL: String , latitude: Double , longitude : Double,_ completionhandler: @escaping (_ success:Bool ,_ error: String?)->Void) {
        self.updateStudentLocation(uniquekey: uniquekey, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (success, error) in
            if let error = error {
                completionhandler(false, "Failed to updata Your location")
            } else {
                completionhandler(true, nil)
            }
        }
        
        
    }
    
    
    
}

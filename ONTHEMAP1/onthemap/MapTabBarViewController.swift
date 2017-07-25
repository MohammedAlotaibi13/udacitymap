//
//  MapTabBarViewController.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٥ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import UIKit

class MapTabBarViewController: UITabBarController  {
    
    @IBAction func PinButoon(_ sender: Any) {
        
        if StudentData.createdAt == ""{
            
            let controller = (self.storyboard?.instantiateViewController(withIdentifier: "StudentLocationController"))! as UIViewController
            DispatchQueue.main.async(){
                self.present(controller, animated: true, completion: nil)
            }
        } else{
            self.alert(massege: "You have Already Posted a Student Location. Would You Like To Overwrite Your Current Location ")
            
        }
        
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        
        
        UdacituApi.sharedinstance().deletingSession { (result, error) in
            if let error = error {
                
                self.alert2("Failed to logout")
            } else {
                print("logout successfully")
                DispatchQueue.main.async(){
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func alert(massege: String){
        let alert = UIAlertController(title: nil, message: massege, preferredStyle: .alert)
        let Overwrite = UIAlertAction(title: "Overwrite", style: .default) { (action) in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "StudentLocationController") as! StudentLocationController
            self.present(controller, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil)
        alert.addAction(Overwrite)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func alert2(_ message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}

//
//  StudentLocationController.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٥ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//


import UIKit
import CoreLocation

class StudentLocationController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var myactivityindicator: UIActivityIndicatorView!
    
    
    
    lazy var gecoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextfield.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        DispatchQueue.main.async(){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func findOnTheMapaButton(_ sender: Any) {
        if locationTextfield.text != "Enter Your Location Here" {
            
            self.myactivityindicator.startAnimating()
            StudentData.mapString = locationTextfield.text!
            
            
            
            
            
            self.processLocation(){ (success, error) in
                
                if success {
                    self.myactivityindicator.stopAnimating()
                    self.myactivityindicator.hidesWhenStopped = true
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SubmitStudentinformationController") as! SubmitStudentinformationController
                    DispatchQueue.main.async(){
                        self.present(controller, animated: true, completion: nil)
                    }
                    
                    
                } else {
                    self.myactivityindicator.stopAnimating()
                    self.myactivityindicator.hidesWhenStopped = true
                    self.alert(error!)
                }
            }
            
            
            
            
        } else {
            self.alert("Plese Enter Your location")
            
        }
        
        
    }
    
    private func processLocation(_ completionhaler:  @escaping (_ success: Bool,_ error: String?)->Void) {
        
        gecoder.geocodeAddressString(StudentData.mapString) { (placemarks, error) in
            
            
            if let error = error {
                print(error)
                completionhaler(false, "Could not Find Your Location")
                
            }
            
            
            guard let placemarks = placemarks else {
                print("No placemarks found")
                completionhaler(false, "failed to find location")
                return
            }
            
            guard let latitude = placemarks[0].location?.coordinate.latitude else {
                print("No latitude")
                completionhaler(false, "Not found latitude")
                return
            }
            guard let longitude = placemarks[0].location?.coordinate.longitude else {
                print("No longitude")
                completionhaler(false, "Not found Longitude")
                return
            }
            
            StudentData.latitude = latitude
            StudentData.longitude = longitude
            print("latitude : \(latitude) longitude : \(longitude)")
            completionhaler(true, nil)
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    func alert(_ massage: String){
        let alert = UIAlertController(title: nil, message: massage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

extension StudentLocationController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextfield.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if locationTextfield.text == "Enter Your Location Here" {
            locationTextfield.text = ""
        }
        
    }
    
    func keyboardwillShow(_ notification:Notification){
        
        if locationTextfield.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
            
        }
        
    }
    
    func keyboardwillHide(_ notification: Notification){
        
        view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification: Notification)-> CGFloat{
        let userinfo = notification.userInfo
        let keyboardsize = userinfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardsize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
    }
    func unsubscribeToKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
    }
    
}

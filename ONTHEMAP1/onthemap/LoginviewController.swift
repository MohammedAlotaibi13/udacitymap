//
//  ViewController.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٣ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import UIKit

class LoginviewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var Debugarea: UILabel!
    @IBOutlet weak var Emailtextfield: UITextField!
    @IBOutlet weak var Passwordtextfield: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var activityindicatir: UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Emailtextfield.delegate = self
        Passwordtextfield.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    @IBAction func LoginButton(_ sender: Any) {
        
        
        if Emailtextfield.text == "" || Passwordtextfield.text == "" {
            Debugarea.text = "There is no Email or Password"
        }else {
            
            self.activityindicatir.startAnimating()
            Contstants.login.username = Emailtextfield.text!
            Contstants.login.password = Passwordtextfield.text!
            
            
            UdacituApi.sharedinstance().authenticateWithViewController(self) { (success, error) in
                
                if success  {
                    self.completeLogin()
                    self.activityindicatir.stopAnimating()
                    self.activityindicatir.hidesWhenStopped = true
                }else {
                    self.activityindicatir.stopAnimating()
                    self.activityindicatir.hidesWhenStopped = true
                    self.alert(error)
                    
                    
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func dontHaveAccount(_ sender: Any) {
        
        // here someone who dont have an acouunt in udaicity
        let signup = Contstants.URLlink.Signup
        let app = UIApplication.shared
        app.open(URL(string: signup)!, options: [:], completionHandler: nil)
    }
    
    
    func completeLogin(){
        
        
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapViewNavigation") as! UINavigationController
        DispatchQueue.main.async(){
            self.present(controller, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    
    
    
    func etUIEnabled(_ enabled: Bool) {
        LoginButton.isEnabled = enabled
        Debugarea.isEnabled = enabled
        
        if enabled {
            LoginButton.alpha = 1.0
        } else {
            LoginButton.alpha = 0.5
        }
    }
    func alert(_ errorString: String?){
        
        let alert = UIAlertController(title: nil, message: errorString, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        DispatchQueue.main.async(){
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}





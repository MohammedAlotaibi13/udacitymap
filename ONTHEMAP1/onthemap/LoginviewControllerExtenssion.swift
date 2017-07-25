//
//  LoginviewControllerExtenssion.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٣ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import Foundation
import UIKit

extension LoginviewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func keyboardwillshow(_ notifiction: Notification){
        if Passwordtextfield.isFirstResponder {
            view.frame.origin.y = -getkeyboardHeight(notifiction)
        }
        
    }
    
    func keyboardwillHide(_ notification: Notification){
        
        view.frame.origin.y = 0
        
    }
    
    func getkeyboardHeight(_ notification: Notification) -> CGFloat{
        
        let userinfo = notification.userInfo
        let Keyboardsize = userinfo? [UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return Keyboardsize.cgRectValue.height
        
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillshow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
}

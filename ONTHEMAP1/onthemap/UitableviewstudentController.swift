//
//  uitableviewstudentController.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٩ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import UIKit

class UitableviewstudentController: UIViewController , UITableViewDataSource , UITableViewDelegate  {
    
    @IBOutlet weak var Tableview: UITableView!
    
    
    
    var studentlocation = StudentArray.sharedInstance.myArray
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Tableview.delegate = self
        Tableview.dataSource = self
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Tableview?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        studentlocation = StudentArray.sharedInstance.myArray
        return studentlocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellReuseId = "StudentCell"
        let studentlocations = studentlocation[(indexPath as NSIndexPath ).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId)! as UITableViewCell
        let firstname = studentlocations.firstname as AnyObject
        let lastname = studentlocations.lastname as AnyObject
        
        cell.textLabel?.text = "\(firstname) \(lastname)"
        cell.imageView?.image = UIImage(named: "pin")
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentlocations = self.studentlocation[(indexPath as NSIndexPath).row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let openURL = studentlocations.mediaurl as? String {
            
            UIApplication.shared.open(URL(string: openURL)!, options: [:], completionHandler: nil)
            
        } else {
            self.alert("Invalid URL")
        }
    }
    
    func alert(_ message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


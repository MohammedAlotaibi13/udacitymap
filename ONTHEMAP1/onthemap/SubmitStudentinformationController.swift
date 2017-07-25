//
//  SumbitStudentinformationController.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٦ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class SubmitStudentinformationController: UIViewController, MKMapViewDelegate , UITextFieldDelegate {
    @IBOutlet weak var linkShareTextfield: UITextField!
    @IBOutlet weak var Mapview: MKMapView!
    @IBOutlet weak var submitbutton: UIButton!
    @IBOutlet weak var myActivity: UIActivityIndicatorView!
    
    
    var mapString = StudentData.mapString
    
    var gecoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkShareTextfield.delegate = self
        
        
        Mapview.delegate = self
        StudentData.mediaURL = linkShareTextfield.text!
        
        gecoder.geocodeAddressString(mapString) { (placemarks, error) in
            
            if let error = error {
                print("unable to find location\(error)")
                self.alert("No location found")
            } else {
                var location : CLLocation?
                
                if let placemarks = placemarks , placemarks.count > 0 {
                    location = placemarks.first?.location
                    
                }
                self.centerMap(location!)
                
            }
            
        }
    }
    
    let regionRadius: CLLocationDistance = 5000
    func centerMap(_ location: CLLocation){
        let coordinate = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0,  regionRadius * 2.0)
        Mapview.setRegion(coordinate, animated: true)
        
    }
    
    
    
    
    
    
    
    @IBAction func submitbutton(_ sender: Any) {
        if linkShareTextfield.text != "Enter a Link to Share Here " {
            
            self.myActivity.startAnimating()
            
            if StudentData.createdAt == ""{
                
                UdacituApi.sharedinstance().postNewStudent(uniqekey: StudentData.userId, mapString: StudentData.mapString, mediaURL: linkShareTextfield.text!, latitude: StudentData.latitude, longitude: StudentData.longitude){ (success, error) in
                    
                    if let error = error {
                        self.myActivity.stopAnimating()
                        self.myActivity.hidesWhenStopped = true
                        self.alert(error)
                        
                        
                    } else {
                        
                        self.processStudentInformation(StudentData.mapString)
                        self.myActivity.stopAnimating()
                        self.myActivity.hidesWhenStopped = true
                    }
                    
                }
                
            }else {
                
                UdacituApi.sharedinstance().updateNewStudent(uniquekey: StudentData.userId, mapString: StudentData.mapString, mediaURL: linkShareTextfield.text!, latitude: StudentData.latitude, longitude: StudentData.longitude) { (success, error) in
                    if let error = error {
                        self.myActivity.stopAnimating()
                        self.myActivity.hidesWhenStopped = true
                        self.alert(error)
                    } else{
                        self.processStudentInformation(StudentData.mapString)
                        self.myActivity.stopAnimating()
                        self.myActivity.hidesWhenStopped = true
                    }
                    
                }
                
            }
            
            
        } else {
            self.alert("Please Enter Your link")
            
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        DispatchQueue.main.async(){
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func processStudentInformation(_ mapstring: String){
        
        
        
        let locationsearsh = MKLocalSearchRequest()
        locationsearsh.naturalLanguageQuery = mapstring
        locationsearsh.region = Mapview.region
        
        let localsearsh = MKLocalSearch(request: locationsearsh)
        localsearsh.start { (response, error) in
            var placemarks = [MKPlacemark]()
            
            if let error = error {
                self.alert("Failed to Post Your Location")
            }
            for response in (response?.mapItems)! {
                placemarks.append(response.placemark)
                
            }
            self.Mapview.showAnnotations([placemarks[0]], animated: false)
            
            let latitude = String(placemarks[0].coordinate.latitude)
            let longitude = String(placemarks[0].coordinate.longitude)
            let mapstring1 = placemarks[0].description
            let uniqekey = StudentData.userId
            let mediaURL = self.linkShareTextfield.text!
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapViewNavigation") as! UINavigationController
            DispatchQueue.main.async(){
                self.present(controller, animated: true, completion: nil)
            }
            
            
        }
        
        
        
    }
    
    func alert (_ message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        DispatchQueue.main.async(){
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
}
extension SubmitStudentinformationController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        linkShareTextfield.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if linkShareTextfield.text == "Enter a Link to Share Here " {
            linkShareTextfield.text = ""
        }
    }
    
}


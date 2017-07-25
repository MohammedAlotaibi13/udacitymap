//
//  MapBarController.swift
//  OnTheMap
//
//  Created by محمد عايض العتيبي on ١٤ شوال، ١٤٣٨ هـ.
//  Copyright © ١٤٣٨ code schoole. All rights reserved.
//

import UIKit
import MapKit
class MapBarController: UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var myactivityindicator: UIActivityIndicatorView!
    @IBOutlet weak var Mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Mapview.delegate = self
        self.myactivityindicator.startAnimating()
        
        UdacituApi.sharedinstance().getStudensData { (studentsinformation, error) in
            if let error = error {
                self.myactivityindicator.stopAnimating()
                self.myactivityindicator.hidesWhenStopped = true
                self.alert(error)
                
            } else {
                
                self.studentLocation()
                self.myactivityindicator.stopAnimating()
                self.myactivityindicator.hidesWhenStopped = true
                
            }
            
        }
        
    }
    func mapView(_ mapview: MKMapView, viewFor annotation: MKAnnotation)->MKAnnotationView? {
        
        let reuseid = "pin"
        
        var pinView = mapview.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else{
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapview: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped controller: UIControl) {
        
        if controller == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: open)!, options: [:], completionHandler: nil)
                
            }
        }
        
    }
    
    func studentLocation(){
        let location = StudentArray.sharedInstance.myArray
        
        var annotations = [MKPointAnnotation]()
        
        for dictionary in location {
            
            if let lat = dictionary.latitude as? Double , let long = dictionary.longitude as? Double {
                print("latitude\(lat) longitude \(long)")
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let firstName = dictionary.firstname as AnyObject
                let lastName = dictionary.lastname as AnyObject
                let mediaURL = dictionary.mediaurl as AnyObject
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(firstName ) \(lastName)"
                annotation.subtitle = mediaURL as? String
                
                annotations.append(annotation)
            }
        }
        
        self.Mapview.addAnnotations(annotations)
        
        
    }
    
    
    
    func alert(_ message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}



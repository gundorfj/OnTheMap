//
//  OTMMapViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class OTMMapViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var otmMapView: MKMapView!
    
    var map = [MKPointAnnotation]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        super.delegate = self
        super.getOTMStudents(force: false)
    }
    
    func populatePins()
    {
        
        let annotations = self.otmMapView.annotations
        if (annotations.count > 0)
        {
            self.otmMapView.removeAnnotations(annotations)
        }
        
        for location in StudentInformations.sharedArray .lastFetched! {
            let long = CLLocationDegrees(location.longitude ?? 0.0)
            let lat = CLLocationDegrees(location.latitude ?? 0.0)
            let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let mediaURL = location.mediaURL ?? " "
            let firstName = location.firstName ?? " "
            let lastName = location.lastName ?? " "
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = cords
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            map.append(annotation)
        }
        self.otmMapView.addAnnotations(self.map)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        let reuseid = "studentpin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle! {
                 
                let url = Helpers.sharedHelper.validateStringToURL(urlString: toOpen)
                if (url != nil)
                {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

extension OTMMapViewController: ModelDelegate {
    func studentsLoaded(_ data: String) {
        debugPrint(data)
        DispatchQueue.main.async {
            self.populatePins()
        }
    }
}

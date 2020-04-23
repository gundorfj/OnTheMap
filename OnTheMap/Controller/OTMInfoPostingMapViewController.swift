//
//  OTMInfoPostingMapViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit
import MapKit

class OTMInfoPostingMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var finderMapView: MKMapView!
    static let shared = OTMInfoPostingMapViewController()
    var location: StudentInformation?
    var locationSelection = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var studenTitle = ""
    var url = ""
    
    var longitude:Double?
    var latitude:Double?
    var name:String?
    var link:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createAnnotation()
    }
    
    func createAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.title = name!
        annotation.subtitle = link!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude ?? 0.0, longitude ?? 0.0)
        self.finderMapView.addAnnotation(annotation)
        
        
        //zooming to location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude ?? 0.0, longitude ?? 0.0)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        self.finderMapView.setRegion(region, animated: true)
        
    }
    
    
    
    @IBAction func finishTapped(_ sender: Any) {
        API.shared.getUser { (success, student, errorMessage) in
            if success {
                print("student?.uniqueKey: \(student?.uniqueKey)")
                DispatchQueue.main.async {
                    self.sendInformation(student!)
                }
            } else {
                DispatchQueue.main.async {
                    print(errorMessage)
                }
            }
        }
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
    
    
    func sendInformation(_ student: StudentInformation){
        var newStudent = student
        newStudent.uniqueKey = student.uniqueKey
        newStudent.firstName = student.firstName
        newStudent.lastName = student.lastName
        newStudent.mapString = name
        newStudent.mediaURL = link
        newStudent.longitude = longitude
        newStudent.latitude = latitude
        API.shared.postStudent(newStudent) { (success, errorMessage) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    print(errorMessage)
                }
            }
        }
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

//
//  OTMInfoPostingViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class OTMInfoPostingViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var otmFindLocationOutlet: UIButton!
    
    var latitude : Double?
    var longitude : Double?
    var student = StudentInformation()

    @IBAction func otmFindLocationAction(_ sender: Any) {
        
        guard name.text != "" else { Helpers.sharedHelper.setupAlert(self,"Field empty", "Name cannot be empty"); return }
        guard link.text != "" else { Helpers.sharedHelper.setupAlert(self,"Link empty", "Link field cannot be empty"); return }
        guard Helpers.sharedHelper.validateStringToURL(urlString: link.text) != nil else { Helpers.sharedHelper.setupAlert(self, "Not allowed", "The link in not a proper url"); return }
        
        ActivityIndicator.startActivityIndicator(view: self.view )
        
        gecodeCoordinates(name.text!) { (success, errorMessage) in
            if success {
                debugPrint("student?.uniqueKey: \(String(describing: self.student.uniqueKey))")
                DispatchQueue.main.async {
                    ActivityIndicator.stopActivityIndicator()
                }
            } else {
                DispatchQueue.main.async {
                    ActivityIndicator.stopActivityIndicator()
                    Helpers.sharedHelper.setupAlert(self, "Not allowed", "Please choose a different location")
                }
            }
        }
    }
   
    
    @IBAction func otmFindCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        link.delegate = self
        name.borderStyle = .roundedRect
        link.borderStyle = .roundedRect
        self.setupNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        self.setupNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
    }
    
    deinit {
       self.removeNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ActivityIndicator.stopActivityIndicator()
    }
    
    func gecodeCoordinates(_ mapstring: String, completion: @escaping (_ success: Bool, _ ErrorMessage: Error?)->()){
        
        let ai = self.startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(mapstring) { (placeMarks, error) in
            ai.stopAnimating()
            if error != nil {
                debugPrint(error?.localizedDescription ?? " ")
                completion (false, error)
                return
            }
            guard let placeMarks = placeMarks else {
                completion (false, MyError.runtimeError("Placemark was not found"))
                return
            }
            debugPrint("placeMarks: \(placeMarks)")
            debugPrint("placeMarks.first?.location?.coordinate: \(String(describing: placeMarks.first?.location?.coordinate))")
            if placeMarks.count <= 0 {
                completion (false, MyError.runtimeError("placeMarks is lower than zero!"))
                return
            }
            
            let locationSelected = placeMarks.first?.location?.coordinate

            self.student.latitude = locationSelected?.latitude
            self.student.longitude = locationSelected?.longitude
            
            self.performSegue(withIdentifier: "whereOnMap", sender: nil)

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "whereOnMap" {
            let vc = segue.destination as! OTMInfoPostingMapViewController
            vc.name = name.text!
            vc.link = link.text!
            vc.latitude = student.latitude
            vc.longitude = student.longitude
        }
    }
}

enum MyError: Error {
    case runtimeError(String)
}


extension OTMInfoPostingViewController {
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .large)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
}



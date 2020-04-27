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
    
    var newLocation = StudentInformation()
    var latitude : Double?
    var longitude : Double?
    
    @IBAction func otmFindLocationAction(_ sender: Any) {
        
        
        CheckInput()

        
  //      let url = Helpers.sharedHelper.validateStringToURL(urlString: toOpen)
//        if (url != nil)
//        {
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        }
//
//
//        if (name.text?.isEmpty)
//        {
//            checkFieldText()
//        }
//
//
//        guard let placeMarks = placeMarks else {
//            print("unable to find location")
//            return
//        }
//
//
//        if (name.text?.isEmpty)! || (link.text?.isEmpty)!  {
//            let alert = UIAlertController(title: "Fill the auth info", message: "Please fill both email and password", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
//                return
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//
        
        
        if   name.text != "" && link.text != "" {
         //   ActivityIndicator.startActivityIndicator(view: self.view )
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = name.text
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            
            activeSearch.start { (response, error) in
                DispatchQueue.main.async {
                    
                    if error != nil {
        //                ActivityIndicator.stopActivityIndicator()
                        print("Location Error : \(error!.localizedDescription)")
                    }else {
     //                   ActivityIndicator.stopActivityIndicator()
                        
                        self.latitude = response?.boundingRegion.center.latitude
                        self.longitude = response?.boundingRegion.center.longitude
                        
                        self.performSegue(withIdentifier: "whereOnMap", sender: nil)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                
                print("error")
            }
        }
    }
    
    
    
    private func CheckInput(){
        

        
//        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
//            let alert = UIAlertController(title: "Fill the auth info", message: "Please fill both email and password", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
//                return
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    func checkFieldText(text: String)
    {
        let alert = UIAlertController(title: "Please fill ", message: "can't be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            return
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func otmFindCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func gecodeCoordinates(_ studentLocation: StudentInformation){
        
    //    let ai = self.startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, error) in
       //     ai.stopAnimating()
            if error != nil {
                print(error?.localizedDescription ?? " ")
                return
            }
            guard let placeMarks = placeMarks else {
                print("unable to find location")
                return
            }
            print("placeMarks: \(placeMarks)")
            print("placeMarks.first?.location?.coordinate: \(String(describing: placeMarks.first?.location?.coordinate))")
            if placeMarks.count <= 0 {
                print("placeMarks is lower than zero!")
                return
            }
            
            let locationSelected = placeMarks.first?.location?.coordinate
            self.newLocation = studentLocation
            self.newLocation.latitude = locationSelected?.latitude
            self.newLocation.longitude = locationSelected?.longitude
            self.performSegue(withIdentifier: "whereOnMap", sender: self.newLocation)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "whereOnMap" {
            let vc = segue.destination as! OTMInfoPostingMapViewController
            vc.name = name.text!
            vc.link = link.text!
            vc.latitude = self.latitude
            vc.longitude = self.longitude
        }
    }
    
}
    
extension OTMInfoPostingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -otmFindLocationOutlet.frame.origin.y+50
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

private extension OTMInfoPostingViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}


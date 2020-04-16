//
//  OTMMapViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class OTMMapViewController: UIViewController {

    @IBAction func OTMLogoutAction(_ sender: Any) {
        
        let otmLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")

        self.view.window?.rootViewController = otmLoginVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
    }
}

//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBAction func LoginButtonAction(_ sender: Any) {
        
        // 1. Sign in user
        // 2. If user name and password are correct take user to pages
        
        let otmTabBar = self.storyboard?.instantiateViewController(withIdentifier: "OTMTabBarController") as! UITabBarController

        self.view.window?.rootViewController = otmTabBar
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

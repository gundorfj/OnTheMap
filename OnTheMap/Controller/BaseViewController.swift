//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 17/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var studentLocation: [StudentInformation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation(_:)))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh(_:)))
        let logout = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(self.logout(_:)))
        self.navigationItem.rightBarButtonItems = [add, refresh]
        self.navigationItem.leftBarButtonItem = logout
    }
    
    @objc private func addLocation(_ sender: Any){
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "OTMInfoPostingViewController") as! UINavigationController
        mapVC.modalPresentationStyle = .fullScreen
        self.present(mapVC, animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: Any){
        API.shared.getStudentsLocations { (result, error) in
            guard let result = result else {
                return
            }
            guard result.count != 0 else{
                return
            }
            self.studentLocation = result
        }
    }
    
    @objc private func logout(_ sender: Any){
        
        API.shared.logout()
         
        let otmLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.view.window?.rootViewController = otmLoginVC
    }
}


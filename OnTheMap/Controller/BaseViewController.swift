//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 17/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var delegate: ModelDelegate?
    
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
    
    @objc private func refresh(_ sender: Any)
    {
        self.getOTMStudents(force: true)
    }
    
    @objc private func logout(_ sender: Any){
        
        API.shared.logout()
         
        let otmLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.view.window?.rootViewController = otmLoginVC
    }

    
    @objc func getOTMStudents(force: Bool)
    {
        if (!force)
        {
            if (StudentInformations.sharedArray.lastFetched?.isEmpty == false)
            {
                guard let capacity = StudentInformations.sharedArray.lastFetched?.count, capacity == 0 else
                {
                    self.delegate?.studentsLoaded("loaded")
                    return
                }
            }
        }
        
        API.shared.getStudentsLocations { (result, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("error")
                    return
                }

                guard result != nil else {
                    let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    return
                }
            }
            StudentInformations.sharedArray.lastFetched = result
            self.delegate?.studentsLoaded("loaded")
        }
    }
}

protocol ModelDelegate: class {
    func studentsLoaded(_ data: String)
}


//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    // Mark: - OutLets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loginbutton: UIButton!
    @IBAction func signUpNoAccountField(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func LoginButtonAction(_ sender: Any) {
        
        setLoggingIn(true)
        CheckInput()

        API.shared.login(emailTextField.text!, passwordTextField.text!) {(success, error) in
            DispatchQueue.main.async {
                // for any error not expeceted
                if let error = error {
                    print(error.localizedDescription)
                    Helpers.sharedHelper.setupAlert(self,"Error", "An error happened")
                }
                
                //  wrong password or Email
                if !success {
                    Helpers.sharedHelper.setupAlert(self,"Invalid Access", "Invalid email or password")
                }
                else
                {
                // If user name and password are correct move to next storyboard
                let otmTabBar = self.storyboard?.instantiateViewController(withIdentifier: "OTMTabBarController") as! UITabBarController
                self.view.window?.rootViewController = otmTabBar
                    
                }
                
                self.setLoggingIn(false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        loginbutton.layer.cornerRadius = 5
        self.setupNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        self.setupNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
        
        loginActivityIndicatorView.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
    
    deinit {
       self.removeNotifications()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        loginActivityIndicatorView.stopAnimating()
    }
    
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            loginActivityIndicatorView.startAnimating()
        } else {
            loginActivityIndicatorView.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginbutton.isEnabled = !loggingIn
    }
    
    private func CheckInput(){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
            Helpers.sharedHelper.setupAlert(self,"Fill the auth info", "Please fill both email and password")
        }
    }
}

//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

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
        setupNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        setupNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
        
        loginActivityIndicatorView.hidesWhenStopped = true
        // Do any additional setup after loading the view.
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
      //  loginViaWebsiteButton.isEnabled = !loggingIn
    }
    
    private func CheckInput(){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
            Helpers.sharedHelper.setupAlert(self,"Fill the auth info", "Please fill both email and password")
        }
    }
}

private extension LoginViewController {
    
    func setupNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if keyboardHeight(notification) > 400 {
        view.frame.origin.y = -keyboardHeight(notification)
        }
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

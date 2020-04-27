//
//  SpinnerView.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 27/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit

struct ActivityIndicator {
    
    private static var myIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func startActivityIndicator(view:UIView){
        myIndicator.hidesWhenStopped = true
        myIndicator.style = .large
        myIndicator.center = view.center
        view.addSubview(myIndicator)
        myIndicator.startAnimating()
    }
    
    static func stopActivityIndicator(){
        myIndicator.stopAnimating()
    }
    
}

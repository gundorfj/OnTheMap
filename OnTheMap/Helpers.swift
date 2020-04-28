//
//  Helpers.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 23/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import Foundation
import MapKit
import SafariServices

class Helpers
{   
    static let sharedHelper = Helpers()
    
    func validateStringToURL(urlString: String?) -> URL?
    {
        var urlPath = ""
        
        if let urlString = urlString
        {
            if urlString.contains("https://")  || urlString.contains("http://")  {
                urlPath = urlString
            } else {
                let newPath = "https://\(urlString)"
                urlPath = newPath
            }
            if canOpenURL(urlPath)
            {
                return URL(string: urlPath)
            }
        }
        return nil
    }
    
    
    private func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    
    func setupAlert(_ vc: UIViewController, _ header: String, _ body: String)
    {
        let alert = UIAlertController(title: header, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            return
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}

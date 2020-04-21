//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 16/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit

struct StudentInformation: Codable {
    var objectId : String?
    var uniqueKey : String?
    var firstName : String?
    var lastName : String?
    var mapString : String?
    var mediaURL : String?
    var latitude : Double?
    var longitude : Double?
    var createdAt : String?
    var updatedAt : String?
    static var lastFetched: [StudentInformation]?
}

struct Result: Codable {
    let results: [StudentInformation]?
}

enum Param: String {
    case updatedAt
}
extension StudentInformation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}

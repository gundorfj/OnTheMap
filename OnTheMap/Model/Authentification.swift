//
//  Authentification.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 16/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit

struct loginRequest: Codable {
    let email: String
    let password: String
}

struct loginResponse: Codable {
    let account: Account
    let session: Session
}

struct getUserResponse: Codable {
    let last_name: String
    let first_name: String
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}

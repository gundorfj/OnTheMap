//
//  StudentInformations.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 24/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import Foundation
class StudentInformations
{
    let fetchingNumberOfStudents: Int = 100

    static let sharedArray = StudentInformations()

    var lastFetched: [StudentInformation]?
}



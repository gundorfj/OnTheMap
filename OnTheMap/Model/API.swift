//
//  API.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 18/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class API: NSObject {
    
    var accountKey: String = ""
    var createdAt : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var mapString : String = ""
    var mediaURL : String = ""
    var objectId : String = ""
    var uniqueKey : String = ""
    var updatedAt : String = ""
    
    static let shared = API()
    
    func login(_ email: String,_ password: String, completion: @escaping (Bool, Error?)->()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            func showError(_ error: String){
                print(error)
            }
            
            guard (error == nil) else {
                completion (false, error)
                return
            }
            
            guard let data = data else {
                showError("No data")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                showError("Status code > 2xx")
                completion (false, error)
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(loginResponse.self, from: newData)
                let accountID = dataDecoded.account.key
                let accountRegister = dataDecoded.account.registered
                let sessionID = dataDecoded.session.id
                let sessionExpire = dataDecoded.session.expiration
                self.accountKey = accountID ?? ""
                print("Authentication Info")
                print("-------------------\n")
                print("Account ID: \(String(describing: accountID!))")
                print("Account registered: \(String(describing: accountRegister!))")
                print("Session ID: \(String(describing: sessionID!))")
                print("Session expire: \(String(describing: sessionExpire!))")
                print("-------------------\n")
                completion (true, nil)
                print("Login is successful!")
            } catch let error {
                print("Error when decoding data\n")
                print(error.localizedDescription)
                completion (false, nil)
                return
            }
        }
        task.resume()
    }
    
    private func showError(_ error: String){
        print(error)
    }
    
    func getStudentsLocations(limit: Int = StudentInformations.sharedArray.fetchingNumberOfStudents, skip: Int = 0, orderBy: Param = .updatedAt, completion: @escaping ([StudentInformation]?, Error?)->()){
        
        
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=\(limit)&skip=\(skip)&order=-\(orderBy)"
        print("urlString: \(urlString)")
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            guard let data = data else {
                print("data error")
                completion(nil, error)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                print("response error")
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                completion(result.results, nil)
            } catch let error {
                print("Error when decoding data\n")
                print(error.localizedDescription)
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func logout(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func displayError(_ error: String){
                print(error)
            }
            guard (error == nil) else {
                return
            }
            guard let data = data else {
                displayError("Data is empty")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                displayError("Status code in range of > 2xx")
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)

            print("Authentication Info")
            print("-------------------\n")
            print(String(data: newData, encoding: .utf8)!)
            print("-------------------\n")
            print("Logout is successful!")
        }
        task.resume()
    }
    
    func getOTMUser(completionHandlerForGet: @escaping (_ success: Bool, _ student: StudentInformation?, _ errorString: String?) -> Void){
        if accountKey == "" {
            completionHandlerForGet(false, nil, "no account key")
            return
        }
        let studentUrl = "https://onthemap-api.udacity.com/v1/users/\(accountKey)"
        print("account key: \(accountKey)")
        print("urlString: \(studentUrl)")
        var request = URLRequest(url: URL(string: studentUrl)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandlerForGet(false, nil, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandlerForGet(false, nil, error?.localizedDescription)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                completionHandlerForGet(false, nil, error?.localizedDescription)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(getUserResponse.self, from: newData)
                var student = StudentInformation()
                student.firstName = decodedData.first_name
                student.lastName = decodedData.last_name
                student.uniqueKey = self.accountKey
                completionHandlerForGet(true, student, nil)
            } catch let error {
                print(error.localizedDescription)
                completionHandlerForGet(false, nil, error.localizedDescription)
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func postOTMStudent(_ student: StudentInformation, completionHandlerPost: @escaping (_ success: Bool, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(student)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandlerPost(false, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandlerPost(false, error?.localizedDescription)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                completionHandlerPost(false, error?.localizedDescription)
                return
            }
            do {
                let decoder = JSONDecoder()
                _ = try decoder.decode(StudentInformation.self, from: data)
                completionHandlerPost(true, nil)
            } catch let error {
                print(error.localizedDescription)
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}


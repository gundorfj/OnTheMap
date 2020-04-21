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
                showError("there is no data")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                showError("the status code > 2xx")
                completion (false, error)
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(loginResponse.self, from: newData)
                let accountID = dataDecoded.account.key
                let accountRegister = dataDecoded.account.registered
                let sessionID = dataDecoded.session.id
                let sessionExpire = dataDecoded.session.expiration
                self.accountKey = accountID ?? ""
                //self.firstName = dataDecoded.account
                print(":: Authentication Information ::")
                print("--------------------------")
                print("The account ID: \(String(describing: accountID!))")
                print("The account registered: \(String(describing: accountRegister!))")
                print("The session ID: \(String(describing: sessionID!))")
                print("The seesion expire: \(String(describing: sessionExpire!))")
                print("--------------------------\n")
                completion (true, nil)
                print("The login is done successfuly!")
            } catch let error {
                showError("could not decode data \(error.localizedDescription)")
                completion (false, nil)
                return
            }
        }
        task.resume()
        
        
    }
    
    private func showError(_ error: String){
        print(error)
    }
    
    func getStudentsLocations(limit: Int = 100, skip: Int = 0, orderBy: Param = .updatedAt, completion: @escaping ([StudentInformation]?, Error?)->()){
        
        
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=\(limit)&skip=\(skip)"
        print("urlString: \(urlString)")
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                completion(nil, error)
                return
            }
            guard let data = data else {
                print("data issue")
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
                let result = try! decoder.decode(Result.self, from: data)
                completion(result.results, nil)
            } catch let error {
                print("there is error in decoding data\n")
                print(error.localizedDescription)
            }
            //print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    func logout(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func dispalyError(_ error: String){
                print(error)
            }
            guard (error == nil) else {
                return
            }
            guard let data = data else {
                dispalyError("Data is empty")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                dispalyError("Status code in range of > 2xx")
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */

            print(":: Authentication Information ::")
            print("--------------------------")
            print(String(data: newData, encoding: .utf8)!)
            print("--------------------------\n")
            print("The logout is done successfuly!")
        }
        task.resume()
    }
    
    func getUser(completionHandlerForGet: @escaping (_ success: Bool, _ student: StudentInformation?, _ errorString: String?) -> Void){
        if accountKey == nil {
            completionHandlerForGet(false, nil, "could not find account key")
            return
        }
        let urlString = "https://onthemap-api.udacity.com/v1/users/\(accountKey)"
        let url = URL(string: urlString)
        print("account key: \(accountKey)")
        print("url is: \(url!)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
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
            print(String(data: data, encoding: .utf8))
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print("--------------")
            print(String(data: newData, encoding: .utf8))
            do {
                let decoder = JSONDecoder()
                let decodedData = try! decoder.decode(StudentInformation.self, from: newData)
                var student = StudentInformation()
                student.firstName = decodedData.firstName
                student.lastName = decodedData.lastName
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
    
    func postStudent(_ student: StudentInformation, completionHandlerPost: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let encoder = JSONEncoder()
        let jsonData: Data
        do {
            jsonData = try encoder.encode(student)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        //            "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
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
                let decodedData = try! decoder.decode(StudentInformation.self, from: data)
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


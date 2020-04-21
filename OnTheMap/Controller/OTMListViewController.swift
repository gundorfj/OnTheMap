//
//  OTMListViewController.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 15/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//
import UIKit

class OTMListViewController: BaseViewController {

    var result = [StudentInformation]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        print("view did load")
        tableView.delegate = self
        tableView.dataSource = self
        result = StudentInformation.lastFetched ?? []
        
        
    }
}

extension OTMListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return result.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentCell
        let student = self.result[(indexPath).row]
        cell.name.text = "\(student.firstName ?? " ")  \(student.lastName ?? " ")"
        cell.imageURL.text = student.mediaURL
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.result[(indexPath).row].mediaURL
        print("url is: \(String(describing: url))")
        if let url = URL(string: url ?? " ")
        {
            UIApplication.shared.open(url)
        }
    }
}

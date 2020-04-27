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
        tableView.delegate = self
        tableView.dataSource = self
        super.delegate = self
        super.getOTMStudents(force: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        result = StudentInformations.sharedArray.lastFetched ?? []
        tableView?.reloadData()
    }
}

extension OTMListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        let url = Helpers.sharedHelper.validateStringToURL(urlString: self.result[(indexPath).row].mediaURL!)
        if (url != nil)
        {
          UIApplication.shared.open(url!)
        }
    }
}


extension OTMListViewController: ModelDelegate {
    func studentsLoaded(_ data: String) {
        print(data)
        result = StudentInformations.sharedArray.lastFetched ?? []

        DispatchQueue.main.async {

            self.tableView?.reloadData()
        }
    }
}

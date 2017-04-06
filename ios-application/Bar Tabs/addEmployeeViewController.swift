//
//  addEmployeeViewController.swift
//  Bar Tabs
//
//  Created by Ron Gerschel on 4/5/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class addEmployeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var employees : JSON?
    
    @IBOutlet var tableView: UITableView!

    
    @IBOutlet var barName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Employees"
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.employees?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            if (self.employees != nil) {
                
                let jsonVar : JSON = self.employees!
                let employeeName = jsonVar[indexPath.row]["formattedName"].rawString()
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "\(employeeName!)"
            }
            return cell
        }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //            showActivityIndicatory(uiView: self.view)
            let jsonVar : JSON = self.employees!
            let objectID = jsonVar[indexPath.row]["employeeId"].int64Value
            deleteRecord(employeeId: objectID)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func fetchData(){
        let service = "employee/getemployees"
        let parameters: Parameters = ["barID" : 4]
        
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.employees = response
            self.tableView.reloadData()
        })
    }
    
    func deleteRecord(employeeId: Int64) {
        let service = "employee/deleteemployee"
        
        let parameters: Parameters = [
            "employeeId" : employeeId
        ]
        
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.fetchData()
            self.tableView.reloadData()
        })
    }

}

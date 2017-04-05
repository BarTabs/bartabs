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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                let employeeName = jsonVar[indexPath.row]["objectID"].int64
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "\(employeeName!)"
            }
            return cell
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
}

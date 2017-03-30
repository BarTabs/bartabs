//
//  orderHistoryViewController.swift
//  Bar Tabs
//
//  Created by Victor Lora on 3/30/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class orderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var orders : JSON?
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.orders?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (self.orders != nil) {
            
            let jsonVar : JSON = self.orders!
            let categories = jsonVar[indexPath.row].string
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = categories
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jsonVar : JSON = self.orders!
        _type = jsonVar[indexPath.row].string
        //performSegue(withIdentifier: "typeSegue", sender: nil)
    }
    
    func fetchData() {
        let service = "order/getuserorders"
        let parameters: Parameters = [
            "userID" : UserDefaults.standard.integer(forKey: "userID")
        ]
        
        let getService = GetService(view: self)
        getService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.orders = response
            self.tableView.reloadData()
        })
    }

    
}

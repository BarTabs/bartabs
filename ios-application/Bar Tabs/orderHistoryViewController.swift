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
        self.automaticallyAdjustsScrollViewInsets = false
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
            let menuItemName = jsonVar[indexPath.row]["name"].string
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = menuItemName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "typeSegue", sender: nil)
    }
    
    func fetchData() {
        let service = "order/getuserorders"
        let parameters: Parameters = [
            "userID" : UserDefaults.standard.integer(forKey: "userID")
        ]
        
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.orders = response
            self.tableView.reloadData()
        })
    }

    
}

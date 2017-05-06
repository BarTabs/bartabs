//
//  openOrdersViewController.swift
//  Bar Tabs
//
//  Created by Victor Lora on 4/6/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller enables employees to view all
    of the orders that need to be completed.  The employee
    can see which user placed the order and complete the order.
    A notification will be sent to the user once his/her order has
    been completed.
*/

import UIKit
import Alamofire
import SwiftyJSON

class OpenOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var orders : JSON?
    var selectedOrder: JSON?
    var timer: Timer?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Open Orders"
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData(showActivityIndicator: true)
        timer = Timer.scheduledTimer(timeInterval: 5, target:self, selector: #selector(self.reloadData), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.orders?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (self.orders != nil) {
            
            let jsonVar : JSON = self.orders!
            let orderID = jsonVar[indexPath.row]["objectID"].int64
            let orderedDate = jsonVar[indexPath.row]["orderedDateDisplay"].stringValue
            cell.textLabel?.text = "Order #" + orderID!.description;
            cell.detailTextLabel?.text = orderedDate
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jsonVar : JSON = self.orders!
        selectedOrder = jsonVar[indexPath.row]
        if let orderID = selectedOrder?["objectID"].int64 {
            let service = "order/getorderitems"
            let parameters: Parameters = [
                "orderID": orderID
            ]
            
            let dataService = DataService(view: self)
            dataService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
                self.performSegue(withIdentifier: "orderSegue", sender: (response.array))
            })
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderSegue" {
            let destSeg = segue.destination as! OrderViewController
            destSeg.items = (sender as? [JSON])!
            destSeg.fromOpenOrder = true
            destSeg.orderID = selectedOrder?["objectID"].int64
            if selectedOrder?["total"] != JSON.null {
                if let total = selectedOrder?["total"].doubleValue {
                    destSeg.total = String(format:"$%.02f", total)
                }
            }
            
        }
    }
    
    func fetchData(showActivityIndicator: Bool) {
        let service = "order/getbarorders"
        let parameters: Parameters = [
            "barID": 4,
            "openOnly": true
        ]
        
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, showActivityIndicator:showActivityIndicator, completion: {(response: JSON) -> Void in
            self.orders = response
            self.tableView.reloadData()
        })
    }
    
    func reloadData() {
        fetchData(showActivityIndicator: false)
    }
    
    
}

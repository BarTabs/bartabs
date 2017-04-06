//
//  orderViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/18/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var _clientOrder = ClientOrder()

class orderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func cancelOrder(_ sender: Any) {
        self.clearOrderItems()
    }
    
    @IBOutlet var orderButtonItem: UIButton!
    
    @IBOutlet var totalLabel: UILabel!
    
    var clientOrder: ClientOrder {
        return _clientOrder
    }
    var item : JSON?
    var fromOpenOrder = false
    var items = [JSON]()
    var orderID: Int64?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var totalPrice: UILabel!
    
    @IBAction func pay(_ sender: Any) {
        handleButtonPush()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (fromOpenOrder) {
            orderButtonItem.setTitle("Complete", for: UIControlState.normal)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        if item != nil {
            var menuItem = ClientMenuItem()
            menuItem.objectID = item?["objectID"].int64Value
            menuItem.menuID = item?["menuID"].int64Value
            menuItem.name = item?["name"].string ?? ""
            menuItem.description = item?["description"].string ?? ""
            menuItem.price = item?["price"].doubleValue
            menuItem.category = item?["category"].string ?? ""
            menuItem.type = item?["type"].string ?? ""
        
            _clientOrder.orderItems.append(menuItem)
            calculateOrderTotal()
        }
        
        
        tableCutomize()
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if items.count > 0 {
            count = items.count
        } else if clientOrder.orderItems.count > 0 {
            count = clientOrder.orderItems.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var name = ""
        
        if items.count > 0 {
            name = items[indexPath.row]["name"].stringValue
        } else if clientOrder.orderItems.count > 0 {
            let menuItem : ClientMenuItem = clientOrder.orderItems[indexPath.row]
            name = menuItem.name ?? ""
        }
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let index = indexPath.row
            _clientOrder.removeOrderItemAt(index: index)
            calculateOrderTotal()
            self.tableView.reloadData()
        }
    }
    

    
    func tableCutomize() {
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 1
    }
    
    func handleButtonPush() {
        if (fromOpenOrder) {
            completeOrder()
        } else {
            placeOrder()
        }
    }
    
    func placeOrder() {
        let service = "order/placeorder"
        let userID = UserDefaults.standard.string(forKey: "userID")!
        _clientOrder.orderedBy = Int64(userID)
        _clientOrder.barID = 4
        
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: clientOrder.dictionaryRepresentation, completion: {(response: JSON) -> Void in
            self.clearOrderItems()
            self.performSegue(withIdentifier: "paySegue", sender: nil)
        })
    }
    
    func completeOrder() {
        let service = "order/completeorder"
        let userID = UserDefaults.standard.string(forKey: "userID")!
        _clientOrder.orderedBy = Int64(userID)
        
        let parameters: Parameters = [
            "completedBy": userID,
            "objectID": orderID ?? "",
            "barID": 4
        ]

        
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.clearOrderItems()
            self.performSegue(withIdentifier: "openOrdersSegue", sender: nil)
        })
    }
    
    func clearOrderItems() {
        _clientOrder.orderItems.removeAll()
        self.tableView.reloadData()
    }
    
    func calculateOrderTotal() {
        totalLabel.text = String(format:"%.02f", self.clientOrder.getTotal())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

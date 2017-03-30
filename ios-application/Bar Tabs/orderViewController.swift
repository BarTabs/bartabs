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
    
    @IBAction func orderButton(_ sender: Any) {
        placeOrder()
    }
    
    @IBOutlet var totalLabel: UILabel!
    
    var clientOrder: ClientOrder {
        return _clientOrder
    }
    var item : JSON?
    var items = [JSON]()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var totalPrice: UILabel!
    
    @IBAction func pay(_ sender: Any) {
        placeOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var menuItem = ClientMenuItem()
        menuItem.objectID = item?["objectID"].int64Value
        menuItem.menuID = item?["menuID"].int64Value
        menuItem.name = item?["name"].string ?? ""
        menuItem.description = item?["description"].string ?? ""
        menuItem.price = item?["price"].doubleValue
        menuItem.category = item?["category"].string ?? ""
        menuItem.type = item?["type"].string ?? ""
        
        _clientOrder.orderItems.append(menuItem)
        totalLabel.text = String(format:"%.02f", self.clientOrder.getTotal())
        
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
        let count = clientOrder.orderItems.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let menuItem : ClientMenuItem = clientOrder.orderItems[indexPath.row]
        let name = menuItem.name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = name
        return cell
    }
    
    func tableCutomize() {
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 1
    }
    
    func placeOrder() {
        let service = "order/placeorder"
        let userID = UserDefaults.standard.string(forKey: "userID")!
        _clientOrder.orderedBy = Int64(userID)
        _clientOrder.barID = 4
        
        let postService = PostService(view: self)
        postService.post(service: service, parameters: clientOrder.dictionaryRepresentation, completion: {(response: JSON) -> Void in
            self.clearOrderItems()
            self.performSegue(withIdentifier: "paySegue", sender: nil)
        })
    }
    
    func clearOrderItems() {
        _clientOrder.orderItems.removeAll()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

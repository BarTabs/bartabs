//
//  orderViewController.swift
//  Bar Tabs
//
//  Created by Victor on 3/18/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller enables users to place orders
    for different items.  There is QR code tied to the user's
    account which enables Employees to scan the code and place
    the order for the user.
*/

import UIKit
import Alamofire
import SwiftyJSON

var _clientOrder = ClientOrder()

class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QRCodeScanHandler {
    
    @IBAction func cancelOrder(_ sender: Any) {
        self.clearOrderItems()
    }
    
    
    @IBOutlet var qrImage: UIButton!
    @IBAction func qrCodeScanButtonClick(_ sender: Any) {
        let qrCodeScanView = QrCodeReaderViewController()
        qrCodeScanView.delegate = self
        self.navigationController?.pushViewController(qrCodeScanView, animated: true)
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
    var total: String?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var totalPrice: UILabel!
    
    
    @IBAction func pay(_ sender: Any) {
        handleButtonPush()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Order"
        
        qrImage.isHidden = true
        let type = UserDefaults.standard.integer(forKey: "userType")
        if type == 2 && !fromOpenOrder {
            qrImage.isHidden = false
            orderButtonItem.isHidden = true
        } else {
            qrImage.isHidden = true
            orderButtonItem.isHidden = false
        }
        
        if (fromOpenOrder) {
            self.navigationItem.title = "Order #" + orderID!.description
            orderButtonItem.setTitle("Complete", for: UIControlState.normal)
            totalPrice.text = total
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
        var price = 0.0
        
        if items.count > 0 {
            name = items[indexPath.row]["name"].stringValue
            price = items[indexPath.row]["price"].doubleValue
        } else if clientOrder.orderItems.count > 0 {
            let menuItem : ClientMenuItem = clientOrder.orderItems[indexPath.row]
            name = menuItem.name ?? ""
            price = menuItem.price ?? 0.0
        }
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = String(format:"$%.02f", price)
        
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
        _clientOrder.total = Decimal(clientOrder.getTotal());
        _clientOrder.barID = 4
        
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: clientOrder.dictionaryRepresentation, completion: {(response: JSON) -> Void in
            self.clearOrderItems()
            self.performSegue(withIdentifier: "paySegue", sender: nil)
        })
    }
    
    func placeOrderViaQrCode(uuid: String) {
        print("order placed")
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
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func clearOrderItems() {
        _clientOrder.orderItems.removeAll()
        self.tableView.reloadData()
    }
    
    func calculateOrderTotal() {
        totalLabel.text = String(format:"$%.02f", self.clientOrder.getTotal())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scannedQRCode(uuid: String) {
        if !uuid.isEmpty {
            let service = "order/placeorderviaqrcode"
            let userID = UserDefaults.standard.string(forKey: "userID")!
            _clientOrder.orderedBy = Int64(userID)
            _clientOrder.total = Decimal(clientOrder.getTotal());
            _clientOrder.barID = 4
            _clientOrder.uuid = uuid
            
            let dataService = DataService(view: self)
            dataService.post(service: service, parameters: clientOrder.dictionaryRepresentation, completion: {(response: JSON) -> Void in
                self.clearOrderItems()
                self.performSegue(withIdentifier: "paySegue", sender: nil)
            })

        }
    }
    
}

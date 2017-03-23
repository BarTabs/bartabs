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

class orderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var itemName: UILabel!
    @IBAction func orderButton(_ sender: Any) {
        placeOrder()
    }
    
    var clientOrder = ClientOrder()
    
    var item : JSON?
    var items = [JSON]()
    
    let url = "http://138.197.87.137:8080/bartabs-server/order/placeorder"
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
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
        
        clientOrder.orderItems.append(menuItem)
        
        tableCutomize()
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backSegue" {
            let destView = segue.destination as! typeViewController
            destView.category = item!["category"].string!
            destView.type = item!["type"].string!
        }
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
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 0.9608, green: 0.9608, blue: 0.8627, alpha: 1.0)
    }
    
    //Create alert function
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Create func for activity indicator to display on screen
    func showActivityIndicatory(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2,
                                           y:loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    //Create func to hide the activity indicator
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    //Create func for rectangular graphic container for activity indicator
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func placeOrder() {
        let userID = UserDefaults.standard.string(forKey: "userID")!
        clientOrder.orderedBy = Int64(userID)
        clientOrder.barID = 4
        
        showActivityIndicatory(uiView: self.view)
        let token = UserDefaults.standard.string(forKey: "token")!
        
        let headers : HTTPHeaders = [
            "Authorization" : token
        ]
        
        URLCache.shared.removeAllCachedResponses()
        
        print(clientOrder.dictionaryRepresentation)
        Alamofire.request(url, method: .post, parameters: clientOrder.dictionaryRepresentation, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if((response.result.value) != nil) {
                self.hideActivityIndicator(uiView: self.view)
                self.performSegue(withIdentifier: "paySegue", sender: nil)
            } else {
                self.hideActivityIndicator(uiView: self.view)
                self.createAlert(titleText: "Order Error", messageText: "Order could not be placed")
            }
        }
    }
    
}

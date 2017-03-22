//
//  orderViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/18/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class orderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var item : JSON?
    var items = [JSON]()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var totalPrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        items.append(item!)
        
        if let price = item?["price"] {
            totalPrice.text = "Total: $\(price)0"
        }
        
        tableCutomize()
        
        
        self.navigationItem.title = "Hello"
//        self.view.backgroundColor = UIColor(red: 0.9608, green: 0.9608, blue: 0.8627, alpha: 1.0)
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
        let count = items.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let jsonVar : [JSON] = items
        let name = jsonVar[indexPath.row]["name"].string
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = name
        return cell
    }
    
    func tableCutomize() {
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 0.9608, green: 0.9608, blue: 0.8627, alpha: 1.0)
    }
}

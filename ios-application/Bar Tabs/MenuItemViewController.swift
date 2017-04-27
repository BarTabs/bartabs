//
//  typeViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/2/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller gets all of the items inside
    the subcategory (i.e. Sam Adams) and displays them
    in a table view.
 */

import UIKit
import Alamofire
import SwiftyJSON

var _type: String?

class MenuItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menu : JSON?
    var type: String {
        return _type ?? ""
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = type
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderSegue" {
            let destSeg = segue.destination as! OrderViewController
            destSeg.item = sender as? JSON
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (self.menu?["menuItems"].count) ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemTableViewCell
        
        if (self.menu != nil) {
            let jsonVar : JSON = self.menu!
            let name = jsonVar["menuItems"][indexPath.row]["name"].stringValue
            let description = jsonVar["menuitems"][indexPath.row]["description"].stringValue
            print(description)
            let price = jsonVar["menuItems"][indexPath.row]["price"].doubleValue
            
            cell.title.text = name
            cell.subtitle.text = "test"
            cell.price.text = String(format:"$%.02f", price)
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jsonVar : JSON = self.menu!
        let item = jsonVar["menuItems"][indexPath.row]
        performSegue(withIdentifier: "orderSegue", sender: item)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //            showActivityIndicatory(uiView: self.view)
            let jsonVar : JSON = self.menu!
            let objectID = jsonVar["menuItems"][indexPath.row]["objectID"].int64Value
            deleteRecord(objectID: objectID)
        }
    }
    
    func fetchData() {
        let service = "menu/getmenu"
        
        let parameters: Parameters = [
            "barID" : 4,
            "category" : _category ?? "-1" ,
            "type" : type
        ]
        
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.menu = response
            self.tableView.reloadData()
        })
    }
    
    func deleteRecord(objectID: Int64) {
        let service = "menu/deletemenuitem"
        
        let parameters: Parameters = [
            "objectID" : objectID
        ]
        
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.fetchData()
        })
    }
    
}

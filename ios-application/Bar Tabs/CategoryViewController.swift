//
//  menuViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/26/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller gets all of the menu categories
    (i.e. Food, Drinks) of the current Bar that the user 
    is at and displays them into a table view.
*/

import UIKit
import Alamofire
import SwiftyJSON

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menu : JSON?
    var bar = ""
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let type = UserDefaults.standard.integer(forKey: "userType")
        if(type == 1 || type == 2) {
            var items = [UIBarButtonItem]()
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
            items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CategoryViewController.addMenuItem)))
            toolbar.items = items
        }
        
        self.navigationItem.title = "Amnesia"
        self.automaticallyAdjustsScrollViewInsets = false

        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor.gray
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return (self.menu?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (self.menu != nil) {
            let jsonVar : JSON = self.menu!
            let categories = jsonVar[indexPath.row].string
            cell.textLabel?.text = categories
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jsonVar : JSON = self.menu!
        _category = jsonVar[indexPath.row].string
        performSegue(withIdentifier: "categorySegue", sender: nil)
    }

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func fetchData() {
        let service = "menu/getmenu"
        let parameters: Parameters = [
            "barID" : 4
        ]
        
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.menu = response
            self.tableView.reloadData()
        })
    }
    
    func addMenuItem() {
        performSegue(withIdentifier: "addMenuSegue", sender: nil)
    }
    
}

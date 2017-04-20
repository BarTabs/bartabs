//
//  drinksViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/2/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller gets all of the sub categories
    (i.e. Beers, Cocktails, Spirits, Mixed Drinks)
    and displays it in a table view.
 */

import UIKit
import Alamofire
import SwiftyJSON

var _category: String?

class categoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menu : JSON?
    var category: String {
        return _category ?? ""
    }
    
    @IBOutlet var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = category
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.menu?.count) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        if (self.menu != nil) {
        
            let jsonVar : JSON = self.menu!
            let categories = jsonVar[indexPath.row].string
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = categories
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jsonVar : JSON = self.menu!
        _type = jsonVar[indexPath.row].string
        performSegue(withIdentifier: "typeSegue", sender: nil)
    }
    
    func fetchData() {
        let service = "menu/getmenu"
        let parameters: Parameters = [
            "barID" : 4,
            "category" : category
        ]
        
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            self.menu = response
            self.tableView.reloadData()
        })
    }


}

//
//  menuViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/26/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class menuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
<<<<<<< Updated upstream
    
    var menu : JSON?
=======
>>>>>>> Stashed changes

    var menu = [AnyObject]()
    
    let url = "http://138.197.87.137:8080/bartabs-server/test"
    
    
    @IBOutlet weak var tableView: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let token = UserDefaults.standard.string(forKey: "token")!
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Create Header token
        let headers : HTTPHeaders = [
            "Authorization" : token
        ]
        
        
<<<<<<< Updated upstream
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if((response.result.value) != nil) {
                self.menu = JSON(response.result.value ?? "success")
                self.tableView.reloadData()
=======
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            let result = response.result
            if let data = result.value as? Dictionary<String, AnyObject> {
                if let name = data["data"] {
                    self.menu = name as! [AnyObject]
                    self.tableView.reloadData()
                }
>>>>>>> Stashed changes
            } else {
                self.createAlert(titleText: "Table Load Error", messageText: "Error loading the table data")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Create table View function for the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
<<<<<<< Updated upstream
//        return menu.count
//        return self.menu.count
        return (self.menu?.count) ?? 0
=======
        return self.menu.count
>>>>>>> Stashed changes
    }
    
    //Create the actual table view itself
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
<<<<<<< Updated upstream

        if (self.menu != nil) {
            let jsonVar : JSON = self.menu!
            print(jsonVar["data"][indexPath.row]["name"])
            
            let category = jsonVar["data"][indexPath.row]["name"].string
            cell.textLabel?.text = category
        }
         return cell
=======
        
        let category = menu[indexPath.row]["name"]
        cell.textLabel?.text = category as? String
        
        return cell
>>>>>>> Stashed changes
    }
    
    //Create an alert function that is used for UIAlerts
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}

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
    
    var menu : JSON?
    
    let url = "http://138.197.87.137:8080/bartabs-server/menu/getmenu"
    
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        let token = UserDefaults.standard.string(forKey: "token")!
        
        let headers : HTTPHeaders = [
            "Authorization" : token
        ]
        
        let parameters: Parameters = [
            "barID" : 4
        ]
        
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if((response.result.value) != nil) {
                self.menu = JSON(response.result.value ?? "success")
                self.tableView.reloadData()
            } else {
                self.createAlert(titleText: "Data Error", messageText: "There was a problem receiving the data")
            }
        }
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
            let categories = jsonVar["data"][indexPath.row].string
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = categories
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jsonVar : JSON = self.menu!
        let categories = jsonVar["data"][indexPath.row].string
        performSegue(withIdentifier: "categorySegue", sender: categories)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categorySegue" {
            let destSeg = segue.destination as! categoryViewController
            destSeg.category = sender as! String
        }
    }
    
    
    
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

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
    
//    var menu: NSDictionary = NSDictionary()
    var menu : JSON?
    //var menu : NSDictionary = NSDictionary()

    let url = "http://138.197.87.137:8080/bartabs-server/test"
    
    
    @IBOutlet weak var tableView: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        let token = UserDefaults.standard.string(forKey: "token")!
        
        let headers : HTTPHeaders = [
            "Authorization" : token
        ]
        
        
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if((response.result.value) != nil) {
                let jsonVar : JSON = JSON(response.result.value ?? "success")
                self.menu = jsonVar
//                self.menu = data["name"]
//                print(self.menu)
                
//                self.menu = NSDictionary(contentsOfFile: String(describing: jsonVar["data"]))!
//                self.menu = jsonVar["data"]
//                print(self.menu)
                
                //print(self.menu?[0]["name"])
                
//                let name = jsonVar["data"][0]["name"]
//                print(name)
                //reponseArray = jsonVar as! Array
                //let name = String(describing: jsonVar["data"][0]["name"])
                //print(jsonVar["data"])
                //print(jsonVar["data"][0]["name"])
                //self.TableData.append(name)
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
//        return menu.count
//        return self.menu.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let category = self.menu?["data"][indexPath.row]["name"] as AnyObject? as? String ?? ""
        cell.textLabel?.text = category
//        cell.imageView?.image = UIImage(named: object["image"]!)
//        cell.otherLabel?.text =  object["otherProperty"]!
        
        return cell
    }
    
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    

}

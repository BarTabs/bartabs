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
    var bar = ""
    let url = "http://138.197.87.137:8080/bartabs-server/menu/getmenu"
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var barName: UILabel!
    
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColorFromRGB(rgbValue: 0x434343)
        showActivityIndicatory(uiView: self.view)
        
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
                self.hideActivityIndicator(uiView: self.view)
                self.barName.text = "Amnesia"
                self.tableView.reloadData()
            } else {
                self.hideActivityIndicator(uiView: self.view)
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
    
    
    //Create an alert function that is used for UIAlerts
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

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

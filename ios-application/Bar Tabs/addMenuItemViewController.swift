//
//  addMenuItemViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/13/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class addMenuItemViewController: UIViewController {
    
    let url = "http://138.197.87.137:8080/bartabs-server/menu/createmenuitem"
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet var itemName: UITextField!
    
    @IBOutlet var itemDesc: UITextField!

    @IBOutlet var itemType: UITextField!
    
    @IBOutlet var itemCategory: UITextField!
    
    @IBOutlet var itemPrice: UITextField!
    
    @IBAction func addItem(_ sender: Any) {
        
        
        let name = itemName.text
        let desc = itemDesc.text
        let type = itemType.text
        let cat  = itemCategory.text
        let price = itemPrice.text
        
        if(name == "" || desc == "" || type == "" || cat == "" || price == "") {
            self.createAlert(titleText: "Error", messageText: "All fields are required")
        } else {
            showActivityIndicatory(uiView: self.view)
            let token = UserDefaults.standard.string(forKey: "token")!
            let headers : HTTPHeaders = [
                "Authorization" : token
            ]
            
            let parameters : Parameters = [
                "name" : name!,
                "description" : desc!,
                "type" : type!,
                "category" : cat!,
                "price" : price!,
                "menuID" : 1
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if((response.result.value) != nil) {
                    self.hideActivityIndicator(uiView: self.view)
                    self.performSegue(withIdentifier: "addItemSegue", sender: self)
                } else {
                    self.hideActivityIndicator(uiView: self.view)
                    self.createAlert(titleText: "Data Error", messageText: "There was a problem receiving the data")
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create Segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addItemSegue") {
            let name = itemName.text
            let destView = segue.destination as! itemAddedViewController
            destView.name = name!
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
}

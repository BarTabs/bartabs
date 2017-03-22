//
//  customerViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/19/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class customerViewController: UIViewController {
    
    let url = "http://138.197.87.137:8080/bartabs-server/user/createuser"
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var userType:Int?
    
    @IBOutlet var userNameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var confirmPasswordField: UITextField!
    
    @IBOutlet var phoneNumberField: UITextField!
    
    @IBAction func createAccount(_ sender: Any) {
        
        let userName = userNameField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        let phoneNumber = phoneNumberField.text!
        
        if(userName == "" && password == "" && confirmPassword == "" && phoneNumber == "") {
            createAlert(titleText: "Registration Error", messageText: "All fields are required")
        } else if(userName == "" || password == "" || confirmPassword == "" || phoneNumber == "") {
            createAlert(titleText: "Registration Error", messageText: "All fields required")
        } else if(password != confirmPassword) {
            createAlert(titleText: "Registration Error", messageText: "Passwords do not match")
        } else {
            showActivityIndicatory(uiView: self.view)
            let phoneNumber = Int(phoneNumberField.text!)!
            
            let parameters : Parameters = [
                "username" : userName,
                "password" : password,
                "phoneNumber" : phoneNumber,
                "userType" : userType!
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                if((response.result.value) != nil) {
                    let jsonVar: JSON = JSON(response.result.value ?? "success")
                    if(jsonVar["status"] == -1) {
                        self.hideActivityIndicator(uiView: self.view)
                        self.createAlert(titleText: "Registration Error", messageText: "Error processing user creation")
                    } else {
                        UserDefaults.standard.set(jsonVar["data"]["objectID"].int64 ?? -1, forKey: "userID")
                        UserDefaults.standard.set(String(describing: jsonVar["data"]["token"]), forKey: "token")
                        UserDefaults.standard.set(String(describing: jsonVar["data"]["firstName"]), forKey: "firstName")
                        UserDefaults.standard.set(String(describing: jsonVar["data"]["username"]), forKey: "username")
                        UserDefaults.standard.set(jsonVar["data"]["userType"].int ?? -1, forKey: "userType")
                        UserDefaults.standard.synchronize()
                        self.hideActivityIndicator(uiView: self.view)
                        self.performSegue(withIdentifier: "welcomeSegue", sender: nil)
                    }
                } else {
                    self.hideActivityIndicator(uiView: self.view)
                    self.createAlert(titleText: "Error", messageText: "There was a problem creating the account")
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

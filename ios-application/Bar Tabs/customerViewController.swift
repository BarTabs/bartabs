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
            let phoneNumber = Int(phoneNumberField.text!)!
            
            let parameters : Parameters = [
                "username" : userName,
                "password" : password,
                "phoneNumber" : phoneNumber,
                "userType" : 4
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                if((response.result.value) != nil) {
                    let jsonVar: JSON = JSON(response.result.value ?? "success")
                    if(jsonVar["status"] == -1) {
                        self.createAlert(titleText: "Registration Error", messageText: "Error processing user creation")
                    } else {
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.set(String(describing: jsonVar["message"]), forKey: "token")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "createCustomerSegue", sender: nil)
                    }
                } else {
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
    
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


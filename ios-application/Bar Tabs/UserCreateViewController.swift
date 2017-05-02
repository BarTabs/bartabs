//
//  customerViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/19/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller is for the creation of a new
    user be it an owner or a customer.
*/

import UIKit
import Alamofire
import SwiftyJSON

class UserCreateViewController: UIViewController {
    
    var userType:Int?
    
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var zip: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    
    @IBOutlet var account: UIButton!
    
    @IBAction func createAccount(_ sender: Any) {
        
        // TODO: Validate with guard
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
                "userType" : userType!
            ]
            
            createUser(parameters: parameters)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.black
        userNameField.layer.cornerRadius = 5
        passwordField.layer.cornerRadius = 5
        confirmPasswordField.layer.cornerRadius = 5
        phoneNumberField.layer.cornerRadius = 5
        firstName.layer.cornerRadius = 5
        lastName.layer.cornerRadius = 5
        address.layer.cornerRadius = 5
        city.layer.cornerRadius = 5
        state.layer.cornerRadius = 5
        zip.layer.cornerRadius = 5
        account.layer.backgroundColor = UIColor(red: 0, green: 0.8392, blue: 0.0275, alpha: 1.0).cgColor
        account.tintColor = UIColor.white
        account.layer.cornerRadius = 5
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
    
    /*
     This function will process the HTTP request for the user login.
     Once the request is made it will store specific parameters tailored
     to that user.  There parameters will enable them to place orders,
     view history, and stay logged into the app.
     */
    
    func createUser(parameters: Parameters) {
        let service = "user/createuser"
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: parameters, completion: { (response: JSON) -> Void in
            UserDefaults.standard.set(response["objectID"].int64 ?? -1, forKey: "userID")
            UserDefaults.standard.set(String(describing: response["token"]), forKey: "token")
            UserDefaults.standard.set(String(describing: response["firstName"]), forKey: "firstName")
            UserDefaults.standard.set(String(describing: response["username"]), forKey: "username")
            UserDefaults.standard.set(response["userType"].int ?? -1, forKey: "userType")
            UserDefaults.standard.synchronize()
            self.registerDeviceForNotifications(fcmToken: _fcmToken ?? "")
            self.performSegue(withIdentifier: "welcomeSegue", sender: nil)
        })
    }
    
    func registerDeviceForNotifications(fcmToken: String) {
        let service = "user/registerfornotifications"
        let parameters : Parameters = [
            "fcmToken" : fcmToken
        ]
        
        let dataService = DataService(view: self, showActivityIndicator: false)
        dataService.fetchData(service: service, parameters: parameters, completion: { (response: JSON) -> Void in
            print("Device registered for notifications")
            return
        })
    }
    
}

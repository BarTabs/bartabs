//
//  ViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/11/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//  
/* 
  This view controller is the home screen for when the app
  loads for the first time.  The user can either log in or
  register a new account.
*/

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class LoginViewController: UIViewController {
    
    //Start parameters
    let url = "http://138.197.87.137:8080/bartabs-server/authenticate"
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var visualEffect: UIVisualEffectView!
    
    var effect: UIVisualEffect!
    
    @IBOutlet var close: UIButton!
    
    
    @IBOutlet var popUp: UIView!
        
    @IBOutlet var userNameField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var pregame: UIButton!
    
    @IBOutlet var login: UIButton!
    
    @IBAction func animate(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func close(_ sender: Any) {
        animateOut()
    }
    
    
    
    @IBAction func login(_ sender: Any) {
    
        let userName = userNameField.text!
        let password = passwordField.text!
        
        if (userName == "" && password == "") {
            createAlert(titleText: "Login Error", messageText: "Username and password are required.")
        } else if(userName == "" || password == "") {
            createAlert(titleText: "Login Error", messageText: "Username and/or password is required.")
        } else {
            let parameters : Parameters = [
                "username" : userName,
                "password" : password
            ]
            
            login(parameters: parameters)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Login"
        
        effect = visualEffect.effect
        visualEffect.effect = nil
        visualEffect.isUserInteractionEnabled = false
        
        //Gets the Firebase ID token tailored to the device
        if let token = FIRInstanceID.instanceID().token() {
            _fcmToken = token.description
            print("InstanceID token: \(token)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        login.layer.cornerRadius = 5
        login.layer.backgroundColor = UIColor(red: 0, green: 0.8392, blue: 0.0275, alpha: 1.0).cgColor
        login.tintColor = UIColor.white
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.backgroundColor = UIColor(red: 0, green: 0.8392, blue: 0.0275, alpha: 1.0).cgColor
        loginButton.tintColor = UIColor.white
        
        pregame.tintColor = UIColor.white
        pregame.layer.cornerRadius = 5
        pregame.layer.backgroundColor = UIColor(red: 0, green: 0.4941, blue: 0.9647, alpha: 1.0).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tokenStored = UserDefaults.standard.object(forKey: "token")

        if(tokenStored != nil) {
            // Register device for notifications
            registerDeviceForNotifications(fcmToken: _fcmToken ?? "")
            performSegue(withIdentifier: "userSegue", sender: nil)
        }
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
    
    func login(parameters: Parameters) {
        let service = "authenticate"
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, completion: { (response: JSON) -> Void in
            UserDefaults.standard.set(response["objectID"].int64 ?? -1, forKey: "userID")
            UserDefaults.standard.set(String(describing: response["token"]), forKey: "token")
            UserDefaults.standard.set(String(describing: response["firstName"]), forKey: "firstName")
            UserDefaults.standard.set(String(describing: response["username"]), forKey: "username")
            UserDefaults.standard.set(response["userType"].int ?? -1, forKey: "userType")
            UserDefaults.standard.set(String(describing: response["uuid"]), forKey: "uuid")
            UserDefaults.standard.synchronize()
            self.registerDeviceForNotifications(fcmToken: _fcmToken ?? "")
            self.performSegue(withIdentifier: "userSegue", sender: nil)
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
    
    func animateIn() {
        self.view.addSubview(popUp)
        popUp.center = self.view.center
        popUp.layer.cornerRadius = 5
        popUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUp.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffect.effect = self.effect
            self.popUp.alpha = 1
            self.popUp.transform = CGAffineTransform.identity
        }
        
        
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.popUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popUp.alpha = 0
            self.visualEffect.effect = nil
        })
    }

}

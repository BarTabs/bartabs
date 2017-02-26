//
//  ViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/11/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let url = "http://138.197.87.137:8080/bartabs-server/authenticate"
    
    @IBOutlet var userNameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
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
            
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                if((response.result.value) != nil) {
                    let jsonVar : JSON = JSON(response.result.value ?? "success")
                    if(jsonVar["status"] == 0) {
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.set(String(describing: jsonVar["message"]), forKey: "token")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "userSegue", sender: nil)
                    } else if(jsonVar["status"] == -1) {
                        self.createAlert(titleText: "Login Error", messageText: "Username and/or Password incorrect")
                    } else {
                        self.createAlert(titleText: "Error", messageText: "Else error")
                    }
                } else {
                    self.createAlert(titleText: "Login Error", messageText: "No response from server")
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //let usernameStored = UserDefaults.standard.string(forKey: "userName")
        let tokenStored = UserDefaults.standard.object(forKey: "token")
        
        if(tokenStored != nil) {
            performSegue(withIdentifier: "userSegue", sender: nil)
        }
    }
    
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

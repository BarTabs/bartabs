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
    
    @IBAction func userLogin(_ sender: Any) {
        
        let userName = userNameField.text!
        let password = passwordField.text!
        
        UserDefaults.standard.set(userName, forKey: "userName")
        
        let parameters: Parameters = [
            "username": userName,
            "password": password
        ]
        
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            if((response.result.value) != nil) {
                let jsonVar : JSON = JSON(response.result.value ?? "success")
                print(jsonVar)
                self.performSegue(withIdentifier: "userLoginSegue", sender: nil)
                UserDefaults.standard.set(String(describing: jsonVar["data"]), forKey: "token")
            } else {
                print(response.result.value ?? "no response")
            }
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let userName = UserDefaults.standard.object(forKey: "userName")
        let token = UserDefaults.standard.object(forKey: "token")
        //UserDefaults.standard.removeObject(forKey: "userName")
        //UserDefaults.standard.removeObject(forKey: "token")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let token = UserDefaults.standard.object(forKey: "token")
        let userName = UserDefaults.standard.object(forKey: "userName")
        if(token != nil) {
            self.performSegue(withIdentifier: "userLoginSegue", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "userLoginSegue") {
            let userName = UserDefaults.standard.object(forKey: "userName")
            let destViewController : userLoginViewController = segue.destination as! userLoginViewController
            destViewController.userName = String(describing: userName!)
        }
    }
}

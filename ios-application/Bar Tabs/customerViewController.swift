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
    
    let url = "http://138.197.87.137:8080/bartabs-server/authenticate"
    
    @IBOutlet var userNameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var phoneNumberField: UITextField!
    
    
    
    @IBAction func createCustomerAccount(_ sender: Any) {
        let userName = userNameField.text
        let password = passwordField.text
        let phoneNumber = Int(phoneNumberField.text!)!
        
        let parameters:  Parameters = [
            "username": userName!,
            "password": password!,
            "phoneNumber": phoneNumber
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            if((response.result.value) != nil) {
                let result: JSON = JSON(response.result.value ?? "success")
                print(result)
            } else {
                print(response.result.value ?? "no response")
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
}

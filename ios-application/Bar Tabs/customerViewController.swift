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
    var result = ""
    
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
        
        print(parameters)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            if((response.result.value) != nil) {
                let jsonVar: JSON = JSON(response.result.value ?? "success")
                print(jsonVar)
                //self.result = jsonVar["username"]
                //print(self.result)
                self.performSegue(withIdentifier: "createCustomerSegue", sender: nil)
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
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "createCustomerSegue") {
            let destViewController: newUserLoginViewController = segue.destination as! newUserLoginViewController
            destViewController.userName = self.result
        }
    }*/
}

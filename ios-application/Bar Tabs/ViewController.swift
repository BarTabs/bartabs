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
    
    @IBOutlet var userNameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func userLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "userLoginSegue", sender: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "userLoginSegue") {
            let destViewController : userLoginViewController = segue.destination as! userLoginViewController
            destViewController.userName = userNameField.text!
        }
    }
}

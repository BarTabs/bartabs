//
//  newEmployeeViewController.swift
//  Bar Tabs
//
//  Created by Ron Gerschel on 4/6/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit

class newEmployeeViewController: UIViewController {

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var middleInitialFied: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

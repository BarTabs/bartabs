//
//  newEmployeeViewController.swift
//  Bar Tabs
//
//  Created by Ron Gerschel on 4/6/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class newEmployeeViewController: UIViewController {

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var middleInitialField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var employee : JSON?
    
    @IBAction func newUser(_ sender: Any) {
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let middleInitial = middleInitialField.text!
        let phoneNumber = phoneNumberField.text!
        let userName = usernameField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        if employee != nil {
            if (firstName == "" && lastName == "" && phoneNumber == "" && userName == "") {
                createAlert(titleText: "Registration Error", messageText: "All fields are required")
            } else if (firstName == "" || lastName == "" || phoneNumber == "" || userName == "") {
                createAlert(titleText: "Registration Error", messageText: "All fields required")
            } else {
                let phoneNumber = Int(phoneNumberField.text!)!
                
                let parameters : Parameters = [
                    "firstName" : firstName,
                    "middleInitial" : middleInitial,
                    "lastName" : lastName,
                    "phoneNumber" : phoneNumber,
                    "username" : userName,
                    "password" : password,
                    "barId" : 4,
                    "userType" : 2,
                    "userId" : employee?["userId"].int64 ?? JSON.null,
                    "employeeId" : employee?["employeeId"].int64 ?? JSON.null
                    ]
                
                updateEmployee(parameters: parameters)
            }
        } else {
            if (firstName == "" && lastName == "" && phoneNumber == "" && userName == "" && password == "" && confirmPassword == "") {
                createAlert(titleText: "Registration Error", messageText: "All fields are required")
            } else if (firstName == "" || lastName == "" || phoneNumber == "" || userName == "" || password == "" || confirmPassword == "") {
                createAlert(titleText: "Registration Error", messageText: "All fields required")
            } else if (password != confirmPassword) {
                createAlert(titleText: "Registration Error", messageText: "Passwords do not match")
            } else {
                let phoneNumber = Int(phoneNumberField.text!)!
                
                let parameters : Parameters = [
                    "firstName" : firstName,
                    "middleInitial" : middleInitial,
                    "lastName" : lastName,
                    "phoneNumber" : phoneNumber,
                    "username" : userName,
                    "password" : password,
                    "barId" : 4,
                    "userType" : 2
                    ]
                
                createEmployee(parameters: parameters)
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if employee != nil {
            if self.employee?["userId"] != JSON.null {
                self.submitButton.setTitle("Update", for: UIControlState.normal)
                self.navigationItem.title = "Edit Employee"
                
                self.passwordField.isHidden = true
                self.confirmPasswordField.isHidden = true
                
                if let firstName = self.employee?["firstName"] {
                    self.firstNameField.text = firstName.description
                    self.navigationItem.title = "Edit " + firstName.description
                }
                if let middleInitial = self.employee?["middleInitial"]{
                    self.middleInitialField.text = middleInitial.description
                }
                if let lastName = self.employee?["lastName"] {
                    self.lastNameField.text = lastName.description
                }
                if let phoneNumber = self.employee?["phoneNumber"] {
                    self.phoneNumberField.text = phoneNumber.description
                }
                if let username = self.employee?["username"] {
                    self.usernameField.text = username.description
                }
            }
        } else {
            submitButton.setTitle("Create Employee", for: UIControlState.normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createEmployee(parameters: Parameters) {
        let service = "employee/createemployee"
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: parameters, completion: { (response: JSON) -> Void in
            self.navigationController?.popViewController(animated: true)        })
    }
    
    func updateEmployee(parameters: Parameters) {
        let service = "employee/updateemployee"
        let dataService = DataService(view:self)
        dataService.post(service: service, parameters: parameters, completion: { (response: JSON) -> Void in
            self.navigationController?.popViewController(animated: true)        })
    }
}

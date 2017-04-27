//
//  userTypeSelectionViewController.swift
//  Bar Tabs
//
//  Created by Victor Lora on 2/26/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller checks to see if the person
    creating a new account chose owner or customer.
    If the owner was selected a 1 is passed and if
    customer is selected a 4 is passed.
*/

import UIKit

class userTypeSelectionViewController: UIViewController {

    @IBOutlet var customer: UIButton!
    
    @IBOutlet var owner: UIButton!
    
    @IBAction func customerSelected(_ sender: Any) {
        performSegue(withIdentifier: "customerViewController", sender: 4)
    }
    @IBAction func ownerSelected(_ sender: Any) {
        performSegue(withIdentifier: "customerViewController", sender: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Account"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "customerViewController") {
            let customerViewController = segue.destination as! customerViewController
            customerViewController.userType = sender as? Int
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customer.layer.backgroundColor = UIColor(red: 0, green: 0.8392, blue: 0.0275, alpha: 1.0).cgColor
        customer.tintColor = UIColor.white
        customer.layer.cornerRadius = 5
        
        owner.layer.backgroundColor = UIColor(red: 0, green: 0.4941, blue: 0.9647, alpha: 1.0).cgColor
        owner.tintColor = UIColor.white
        owner.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        
    }
}

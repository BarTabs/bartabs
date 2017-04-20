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

}

//
//  userTypeSelectionViewController.swift
//  Bar Tabs
//
//  Created by admin on 2/26/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

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

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "customerViewController") {
            let customerViewController = segue.destination as! customerViewController
            customerViewController.userType = sender as? Int
        }
    }

}

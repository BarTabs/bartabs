//
//  userLoginViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/19/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit

class userLoginViewController: UIViewController {
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "userType")
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    var condition: Bool = false
    
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let firstName = UserDefaults.standard.string(forKey: "firstName") {
            if (firstName != "null" && !firstName.isEmpty) {
                welcomeLabel.text = "Welcome \(firstName)!"
            } else if let username = UserDefaults.standard.string(forKey: "username") {
                welcomeLabel.text = "Welcome \(username)!"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let tokenStored = UserDefaults.standard.object(forKey: "token")
        if(tokenStored == nil) {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    
}

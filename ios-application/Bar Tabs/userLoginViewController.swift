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
    
    @IBOutlet var addMenuItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let type = UserDefaults.standard.integer(forKey: "userType")
        if(type == 4) {
            addMenuItem.isHidden = true
        } else {
            addMenuItem.isHidden = false
        }
        
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
        super.viewDidAppear(animated)
        let tokenStored = UserDefaults.standard.object(forKey: "token")
        if(tokenStored == nil) {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2157, green: 0.2157, blue: 0.2157, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
}

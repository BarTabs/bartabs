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
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            welcomeLabel.text = "Welcome \(userName)!"
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

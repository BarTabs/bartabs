//
//  userLoginViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 2/19/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    @IBOutlet var scrollView: UIScrollView!
    
    var condition: Bool = false
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var historyMenuButton: UIButton!
    @IBOutlet var ordersMenuButton: UIButton!
    @IBOutlet var employees: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let qrcode = UIViewController(nibName: "qrcodeViewController", bundle: nil)
        self.addChildViewController(qrcode)
        self.scrollView.addSubview(qrcode.view)
        qrcode.didMove(toParentViewController: self)
        
        var qrcodeFrame: CGRect = qrcode.view.frame
        qrcodeFrame.origin.y = self.view.frame.height
        
        qrcode.view.frame = qrcodeFrame
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight*2)
        
        let type = UserDefaults.standard.integer(forKey: "userType")
        
        if(type == 1) {
            ordersMenuButton.isHidden = false
            employees.isHidden = false
        } else {
            employees.isHidden = true
        }

        if (type == 4) {
            ordersMenuButton.isHidden = true
        }
        
        if(type == 4 || type == 2 || type == 3) {
            historyMenuButton.isHidden = false
        } else {
            historyMenuButton.isHidden = true
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
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2157, green: 0.2157, blue: 0.2157, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
}

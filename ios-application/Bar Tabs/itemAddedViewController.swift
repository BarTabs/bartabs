//
//  itemAddedViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/15/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller displays the name of the 
    menu item that was just added by the owner.
*/

import UIKit

class itemAddedViewController: UIViewController {
    
    var name = ""

    @IBOutlet var menuItem: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        menuItem.text = "\(name) has been added"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

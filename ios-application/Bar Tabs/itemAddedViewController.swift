//
//  itemAddedViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/15/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit

class itemAddedViewController: UIViewController {
    
    var name = ""
    var desc = ""
    var type = ""
    var cat  = ""
    var price = ""

    @IBOutlet var menuItem: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        menuItem.text = "\(name) has been added"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

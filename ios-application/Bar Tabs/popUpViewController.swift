//
//  popUpViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 5/1/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class popUpViewController: UIViewController {
    
    
    var item : JSON?
    
    @IBOutlet var popUp: UIView!
    
    @IBOutlet var itemName: UILabel!

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUp.layer.cornerRadius = 5
        
        let menuItem = item?["name"].string
        itemName.text = menuItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

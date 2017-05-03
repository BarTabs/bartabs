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

    @IBOutlet var quantity: UILabel!
    
    @IBOutlet var quantityType: UILabel!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUp.layer.cornerRadius = 5
        
        if item != nil {
            if let ingredients = item?["ingredients"][0]["name"].string {
                itemName.text = ingredients
            } else {
                itemName.text = "No ingredients available"
            }
            if let ingredQuantity = item?["ingredients"][0]["quantity"].string {
                quantity.text = "Quantity: \(ingredQuantity)"
            } else {
                quantity.text = "No quantity available"
            }
            if let quanType = item?["ingredients"][0]["quantityType"].string {
                 quantityType.text = "Quantity Type: \(quanType)"
            } else {
                quantityType.text = "No quantity type available"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

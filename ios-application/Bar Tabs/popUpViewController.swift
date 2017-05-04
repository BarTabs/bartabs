//
//  popUpViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 5/1/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//  This code is distributed under the terms and conditions of the MIT license.



import UIKit
import SwiftyJSON

class popUpViewController: UIViewController {
    
    
    var item : JSON?
    var i = 40
    
    @IBOutlet var popUp: UIView!
    
    @IBOutlet var noIngredients: UILabel!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.layer.cornerRadius = 5
        
        for (_, items) in item!["ingredients"] {
            if let ingredients = items["name"].string {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 21))
                label.center = CGPoint(x: 190, y: 205+i)
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.text = ingredients
                i += 40
                noIngredients.isHidden = true
                self.view.addSubview(label)
            }
        }
        
        noIngredients.text = "No ingredients available"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

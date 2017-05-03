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
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.layer.cornerRadius = 5
        
        print(item!["ingredients"].string)
        
        if(item!["ingredients"] != nil) {
        
            for (_, items) in item!["ingredients"] {
                if let ingredients = items["name"].string {
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 21))
                    label.center = CGPoint(x: 190, y: 205+i)
                    label.textAlignment = .center
                    label.textColor = UIColor.white
                    label.text = ingredients
                    i += 40
                    self.view.addSubview(label)
                }
            }
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 21))
            label.center = CGPoint(x: 190, y: 205+i)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.text = "No ingredients found"
            self.view.addSubview(label)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

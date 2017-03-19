//
//  orderViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/18/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class orderViewController: UIViewController {
    
    @IBOutlet var itemName: UILabel!
    var item : JSON?
    var items = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temp = UserDefaults.standard.object(forKey: "items")
        print(temp ?? "Nil")
        if (temp != nil) {
            items = UserDefaults.standard.object(forKey: "items") as! [JSON];
            items.append(item! as JSON)
            UserDefaults.standard.set(items, forKey: "items")
//            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: items), forKey: "items")
            UserDefaults.standard.synchronize()
        } else {
            itemName.text = item?["name"].string ?? ""
            items.append(item! as JSON)
            UserDefaults.standard.set(items, forKey: "items")
//            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: items), forKey: "items")
            UserDefaults.standard.synchronize()
        }
        
         print(items)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backSegue" {
            let destView = segue.destination as! typeViewController
            destView.category = item!["category"].string!
            destView.type = item!["type"].string!
        }
    }
    

}

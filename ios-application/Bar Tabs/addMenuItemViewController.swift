//
//  addMenuItemViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 3/13/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller enables owners to add new items
    to the bar's menu.
*/

import UIKit
import Alamofire
import SwiftyJSON

class addMenuItemViewController: UIViewController {
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet var itemName: UITextField!
    
    @IBOutlet var itemDesc: UITextField!

    @IBOutlet var itemType: UITextField!
    
    @IBOutlet var itemCategory: UITextField!
    
    @IBOutlet var itemPrice: UITextField!
    
    @IBAction func addItem(_ sender: Any) {
        
        let service = "menu/createmenuitem"
        
        let name = itemName.text
        let desc = itemDesc.text
        let type = itemType.text
        let cat  = itemCategory.text
        let price = itemPrice.text
        
        if(name == "" || desc == "" || type == "" || cat == "" || price == "") {
            self.createAlert(titleText: "Error", messageText: "All fields are required")
        } else {
            
            var menuItem = ClientMenuItem()
            menuItem.name = name!
            menuItem.description = desc!
            menuItem.type = type!
            menuItem.category = cat!
            menuItem.price = Double(price!)
            menuItem.menuID = 1
            
            let dataService = DataService(view: self)
            dataService.post(service: service, parameters: menuItem.dictionaryRepresentation, completion: {(response: JSON) -> Void in
                self.performSegue(withIdentifier: "addItemSegue", sender: self)
            })

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Menu Item"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create Segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addItemSegue") {
            let name = itemName.text
            let destView = segue.destination as! itemAddedViewController
            destView.name = name!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
    }

    
    //Create an alert function that is used for UIAlerts
    func createAlert(titleText: String, messageText: String) {
        
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

//
//  MenuItem.swift
//  Bar Tabs
//
//  Created by admin on 3/22/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit

struct ClientMenuItem {
    var objectID: Int64?
    var menuID: Int64?
    var name: String?
    var description: String?
    var price: Double?
    var category: String?
    var type: String?
    
    var dictionaryRepresentation: [String: Any] {
        var dict = [String: Any]()
        
        if (self.objectID != nil) {
            dict["objectID"] = self.objectID!
        }
        
        if (self.menuID != nil) {
            dict["menuID"] = self.menuID!
        }
        
        if (self.name != nil) {
            dict["name"] = self.name!
        }
        
        if (self.description != nil) {
            dict["description"] = self.description!
        }

        if (self.price != nil) {
            dict["price"] = self.price!
        }
        
        if (self.category != nil) {
            dict["category"] = self.category!
        }

        if (self.type != nil) {
            dict["type"] = self.type!
        }
        
        return dict
    }

}

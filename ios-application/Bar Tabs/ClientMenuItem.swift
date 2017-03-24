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
        
        if let objectID = self.objectID {
            dict["objectID"] = objectID
        }
        
        if let menuID = self.menuID {
            dict["menuID"] = menuID
        }
        
        if let name = self.name {
            dict["name"] = name
        }
        
        if let description = self.description {
            dict["description"] = description
        }

        if let price = self.price {
            dict["price"] = price
        }
        
        if let category = self.category {
            dict["category"] = category
        }

        if let type = self.type {
            dict["type"] = type
        }
        
        return dict
    }

}

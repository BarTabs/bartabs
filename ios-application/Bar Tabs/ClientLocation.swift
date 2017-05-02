//
//  ClientLocation.swift
//  Bar Tabs
//
//  Created by Victor Lora on 5/1/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import Foundation

struct ClientLocation {
    var objectID: Int64?
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var zip: String?
    var latitude: String?
    var longitude: String?
    var radius: Double?

    
    
    init() {
        self.objectID = nil
        self.address1 = nil
        self.address2 = nil
        self.city = nil
        self.state = nil
        self.zip = nil
        self.latitude = nil
        self.longitude = nil
        self.radius = nil
    }
    
    var dictionaryRepresentation: [String: Any] {
        var dict = [String: Any]()
        
        if let objectID = self.objectID {
            dict["objectID"] = objectID
        }
        
        if let address1 = self.address1 {
            dict["address1"] = address1
        }
        
        if let address2 = self.address2 {
            dict["address2"] = address2
        }
        
        if let city = self.city {
            dict["city"] = city
        }
        
        if  let state = self.state {
            dict["state"] = state
        }
        
        if  let zip = self.zip {
            dict["zip"] = zip
        }

        if  let latitude = self.latitude {
            dict["latitude"] = latitude
        }

        if  let longitude = self.longitude {
            dict["longitude"] = longitude
        }

        if  let radius = self.radius {
            dict["radius"] = radius
        }

        
        return dict
    }

    
}

//
//  ClientBar.swift
//  Bar Tabs
//
//  Created by Victor Lora on 5/1/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import Foundation

struct ClientBar {
    var objectID: Int64?
    var name: String?
    var locationID: Int64?
    var location: ClientLocation?
    var ownerID: Int64?
    
    
    
    init() {
        self.objectID = nil
        self.name = nil
        self.location = ClientLocation()
    }
    
    init(geotification: Geotification) {
        self.objectID = nil
        self.name = geotification.name
        
        var location = ClientLocation()
        location.latitude = geotification.coordinate.latitude.description
        location.longitude = geotification.coordinate.longitude.description
        location.radius = geotification.radius
        
        self.location = location
    }
    
    mutating func setOwnerID(ownerID: Int64) {
        self.ownerID = ownerID
    }
    
    var dictionaryRepresentation: [String: Any] {
        var dict = [String: Any]()
        
        if let objectID = self.objectID {
            dict["objectID"] = objectID
        }
        
        if let name = self.name {
            dict["name"] = name
        }
        
        if let ownerID = self.ownerID {
            dict["ownerID"] = ownerID
        }
        
        if let locationID = self.locationID {
            dict["locationID"] = locationID
        }
        
        dict["location"] = self.location?.dictionaryRepresentation
        
        return dict
    }

}

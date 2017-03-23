//
//  Order.swift
//  Bar Tabs
//
//  Created by admin on 3/22/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit

struct ClientOrder {
    var objectID: Int64?
    var barID: Int64?
    var total: Decimal?
    var orderedBy: Int64?
    var orderedByDisplay: String?
    var orderedDate: Date?
    var orderedDateDisplay: String?
    var completed: Bool?
    var completedBy: Int64?
    var completedByDisplay: String?
    var completedDate: Date?
    var completedDateDisplay: String?
    
    var orderItems = [ClientMenuItem]()

    var dictionaryRepresentation: [String: Any] {
        var dict = [String: Any]()
        
        if (self.objectID != nil) {
            dict["objectID"] = self.objectID!
        }
        
        if (self.barID != nil) {
            dict["barID"] = self.barID!
        }
        
        if (self.total != nil) {
            dict["total"] = self.total!
        }
        
        if (self.orderedBy != nil) {
            dict["orderedBy"] = self.orderedBy!
        }
        
        if (self.orderedByDisplay != nil) {
            dict["orderedByDisplay"] = self.orderedByDisplay!
        }
        
        if (self.orderedDate != nil) {
            dict["orderedDate"] = self.orderedDate!
        }
        
        if (self.completedByDisplay != nil) {
            dict["completedByDisplay"] = self.completedByDisplay!
        }
        
        if (self.completed != nil) {
            dict["completed"] = self.completed!
        }
        
        if (self.completedByDisplay != nil) {
            dict["completedByDisplay"] = self.completedByDisplay!
        }
        
        if (self.completedDate != nil) {
            dict["completedDate"] = self.completedDate!
        }
        
        if (self.completedDateDisplay != nil) {
            dict["completedDateDisplay"] = self.completedDateDisplay!
        }
        
        var items = [Any]()
        
        for clientMenuItem in self.orderItems {
            items.append(clientMenuItem.dictionaryRepresentation)
        }
        
        dict["orderItems"] = items as Array
        
        return dict
    }
    
    init() {
        self.objectID = nil
        self.barID = nil
        self.total = nil
        self.orderedBy = nil
        self.orderedByDisplay = nil
        self.orderedDate = nil
        self.orderedDateDisplay = nil
        self.completed = nil
        self.completedBy = nil
        self.completedByDisplay = nil
        self.completedDate = nil
        self.completedDateDisplay = nil
        self.orderItems = [ClientMenuItem]()
    }
}

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
    var uuid: String?
    
    var orderItems = [ClientMenuItem]()

    var dictionaryRepresentation: [String: Any] {
        var dict = [String: Any]()
        
        if let objectID = self.objectID {
            dict["objectID"] = objectID
        }
        
        if let barID = self.barID {
            dict["barID"] = barID
        }
        
        if let total = self.total {
            dict["total"] = total
        }
        
        if let orderedBy = self.orderedBy {
            dict["orderedBy"] = orderedBy
        }
        
        if let orderedByDisplay = self.orderedByDisplay {
            dict["orderedByDisplay"] = orderedByDisplay
        }
        
        if let orderedDate = self.orderedDate {
            dict["orderedDate"] = orderedDate
        }
        
        if let completedByDisplay = self.completedByDisplay {
            dict["completedByDisplay"] = completedByDisplay;
        }
        
        if let completed = self.completed {
            dict["completed"] = completed
        }
        
        if let completedByDisplay = self.completedByDisplay {
            dict["completedByDisplay"] = completedByDisplay
        }
        
        if let completedDate = self.completedDate {
            dict["completedDate"] = completedDate
        }
        
        if  let completedDateDisplay = self.completedDateDisplay {
            dict["completedDateDisplay"] = completedDateDisplay
        }
        
        if  let uuid = self.uuid {
            dict["uuid"] = uuid
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
        self.uuid = nil
    }
    
    func getTotal() -> Double {
        var total = 0.0
        
        for clientMenuItem in self.orderItems {
            total += clientMenuItem.price!
        }
        
        return total

    }
    
    mutating func removeOrderItemAt(index: Int) {
        self.orderItems.remove(at: index)
    }
    
    mutating func removeOrderItemByID(id: Int64) {
        let items = self.orderItems
        for i in 0...items.count {
            let item: ClientMenuItem = items[i]
            if item.objectID == id {
                self.orderItems.remove(at: i)
                return
            }
        }
    }
}

//
//  menuItemTableViewCell.swift
//  Bar Tabs
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

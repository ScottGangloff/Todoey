//
//  itemModel.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/4/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import Foundation

class Item
{
    var itemName : String = ""
    var itemChecked : Bool = false
    
    init(itemName : String, itemChecked : Bool)
    {
        self.itemName = itemName
        self.itemChecked = itemChecked
    }
}

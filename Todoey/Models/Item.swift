//
//  itemModel.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/4/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import Foundation
//Make the class of type Encodable and Decodable so it can be written to the plist
//The class can only have primitive data types
class Item: Codable
{
    var itemName : String = ""
    var itemChecked : Bool = false
    
    init(itemName : String, itemChecked : Bool)
    {
        self.itemName = itemName
        self.itemChecked = itemChecked
    }
}

//
//  Item.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/13/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    //Inverse relationship. Each Item has an object. This relationship will be referenced in the var parentCategory
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

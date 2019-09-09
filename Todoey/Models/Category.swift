//
//  Category.swift
//  Todoey
//
//  Created by Scott Gangloff on 8/13/19.
//  Copyright © 2019 Scott Gangloff. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object
{
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    //This line below represents the relationship between Category and Item
    //Each category will have an empty List of item objects that it points to
    //The List keyword is essentially an array but used by Realm to establish relationships
    //You must also specify the inverse relationship in the Item class
    let items = List<Item>()
}

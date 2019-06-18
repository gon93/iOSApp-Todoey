//
//  item.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/6/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

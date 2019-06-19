//
//  Category.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/6/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var hexColor : String = ""
    let items = List<Item>()
    
}

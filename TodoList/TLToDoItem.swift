//
//  TLToDoItem.swift
//  TodoList
//
//  Created by Sky on 9/12/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import RealmSwift

class TLToDoItem: Object {
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var priority: Int = 1
    dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//
//  Item.swift
//  To Doey
//
//  Created by Harry Wright on 17/10/2019.
//  Copyright © 2019 Harry Wright. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var itemContent : String = ""
    @objc dynamic var itemStatus : Bool = false
    var parent = LinkingObjects(fromType: ItemCategory.self, property: "items")
}

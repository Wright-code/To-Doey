 //
//  ItemCategory.swift
//  To Doey
//
//  Created by Harry Wright on 17/10/2019.
//  Copyright © 2019 Harry Wright. All rights reserved.
//

import Foundation
import RealmSwift
 
 class ItemCategory: Object {
    @objc dynamic var categoryTitle : String = ""
    let items = List<Item>()
 }

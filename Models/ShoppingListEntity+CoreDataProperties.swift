//
//  ShoppingListEntity+CoreDataProperties.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//

import CoreData

extension ShoppingListEntity {
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var products: NSSet?
}

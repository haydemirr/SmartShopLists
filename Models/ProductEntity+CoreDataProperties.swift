//
//  ProductEntity+CoreDataProperties.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//

import CoreData

extension ProductEntity {
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var priority: String?
    @NSManaged public var isPurchased: Bool
    @NSManaged public var list: ShoppingListEntity?
}

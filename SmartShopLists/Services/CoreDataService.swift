//
//  CoreDataService.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "SmartShopLists")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData yüklenemedi: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }

    func createList(name: String) -> ShoppingListEntity {
        let listEntity = ShoppingListEntity(context: context)
        listEntity.id = UUID().uuidString
        listEntity.name = name
        listEntity.createdAt = Date()
        listEntity.syncStatus = "created" // Yeni liste oluşturulduğunda syncStatus
        saveContext()
        return listEntity
    }

    func addProduct(to list: ShoppingListEntity, name: String, category: String, priority: String) {
        let productEntity = ProductEntity(context: context)
        productEntity.id = UUID().uuidString
        productEntity.name = name
        productEntity.category = category
        productEntity.priority = priority
        productEntity.isPurchased = false

        let productsSet = list.products?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
        productsSet.add(productEntity)
        list.products = productsSet
        productEntity.list = list
        list.syncStatus = "updated" // Ürün eklendiğinde liste güncellendi
        saveContext()
    }

    func fetchList(by id: String) -> ShoppingListEntity? {
        let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return try? context.fetch(request).first
    }

    func fetchLists() -> [ShoppingListEntity] {
        let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    func fetchUnsyncedLists() -> [ShoppingListEntity] {
        let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "syncStatus != nil")
        return (try? context.fetch(request)) ?? []
    }

    func deleteProduct(_ product: ProductEntity) {
        if let list = product.list {
            list.syncStatus = "updated"
        }
        context.delete(product)
        saveContext()
    }

    func deleteList(_ list: ShoppingListEntity) {
        list.syncStatus = "deleted"
        context.delete(list)
        saveContext()
    }
}

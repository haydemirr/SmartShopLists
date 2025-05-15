//
//  ListVM.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//
import Foundation

class ListVM {
    private let coreDataService: CoreDataService
    var lists: [ShoppingListEntity] = []
    var onListsUpdated: (() -> Void)?

    init(coreDataService: CoreDataService = .shared) {
        self.coreDataService = coreDataService
        fetchLists()
    }

    func fetchLists() {
        lists = coreDataService.fetchLists()
        onListsUpdated?()
    }

    func createList(name: String) {
        let newList = coreDataService.createList(name: name)
        lists.append(newList)
        onListsUpdated?()
    }

    func deleteList(_ list: ShoppingListEntity) {
        coreDataService.deleteList(list)
        lists.removeAll { $0.id == list.id }
        onListsUpdated?()
    }
}

//
//  MockApi.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/13/21.
//

import Foundation
import Combine

protocol Filterable {
    func contains(_ string: String) -> Bool
}

class MockAPI<T: Codable & Equatable & Filterable> {
        
    
    let itemLoader: ItemLoader<T>
    let type: T.Type
    
    private var userItemsSubject = PassthroughSubject<[T], Never>()
    public var items: [T] = []

    init(fileName: String, type: T.Type) {
        self.type = type
        self.itemLoader = ItemLoader(fileName: fileName, type: type)
    }
    
    func getMockItems(filter: String?) -> AnyPublisher<[T], Error> {
        return Publishers.asyncAfter(deadline: self.randomDelayMs) {
            return self.loadRepeatingItems(count: 20, filter: filter)
        }
    }
    
    func getUserItems() -> AnyPublisher<[T], Error> {
        return Publishers.asyncAfter(deadline:  self.randomDelayMs) {
            let items = self.itemLoader.loadItems()
            self.items = items
            self.userItemsSubject.send(self.items)
            self.itemLoader.saveItems(items)
            return items
        }
    }
    
    func userItems() -> AnyPublisher<[T], Never> {
        return userItemsSubject.eraseToAnyPublisher()
    }
    
    func createItem(item: T) -> AnyPublisher<T, Error> {
        return Publishers.asyncAfter(deadline:  self.randomDelayMs) {
            self.items.insert(item, at: 0)
            self.userItemsSubject.send(self.items)
            self.itemLoader.saveItems(self.items)
            return item
        }
    }
    
    func editItem(item: T) -> AnyPublisher<T, Error> {
        return Publishers.asyncAfter(deadline:  self.randomDelayMs) {
            if let index = self.items.firstIndex(of: item) {
                self.items.remove(at: index)
                self.items.insert(item, at: index)
                self.userItemsSubject.send(self.items)
                self.itemLoader.saveItems(self.items)
            }
            return item
        }
    }

    func deleteItem(item: T) -> AnyPublisher<T, Error> {
        return Publishers.asyncAfter(deadline:  self.randomDelayMs) {
            if let index = self.items.firstIndex(of: item) {
                self.items.remove(at: index)
                self.userItemsSubject.send(self.items)
                self.itemLoader.saveItems(self.items)
            }
            return item
        }
    }
    
    
    private func loadRepeatingItems(count: Int, filter: String?) -> [T] {
        let mockItems = itemLoader.loadBundleItems()
        let repeatingItems = Array(repeating: mockItems, count: count).flatMap { $0 }
        if let filter = filter, !filter.isEmpty {
            return repeatingItems.filter { query in
                return query.contains(filter)
            }
        } else {
            return repeatingItems
        }
    }
    
    var randomDelayMs: DispatchTime  { .now() + .milliseconds(Int.random(in: 1000...2000)) }
}

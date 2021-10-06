//
//  ItemLoader.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/13/21.
//

import Foundation

class ItemLoader<T: Codable> {
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    let fileName: String
    let type: T.Type
    
    init(fileName: String, type: T.Type) {
        self.fileName = fileName
        self.type = type
        jsonEncoder.dateEncodingStrategy = .iso8601withFractionalSeconds
        jsonDecoder.dateDecodingStrategy = .iso8601withFractionalSeconds
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    public func loadBundleItems() -> [T] {
        if let items = loadItemsFromBundle() {
            return items
        }
        return []
    }
    
    public func loadBundleItem() throws -> T {
        return try loadItemFromBundle()
    }
 
    public func loadItems() -> [T] {
        if let items = loadItemsFromDocuments() {
            return items
        } else if let items = loadItemsFromBundle() {
            return items
        }
        return []
    }
    
    public func saveItems(_ items: [T]) {
        guard let fileURL = documentsDirectoryURL?.appendingPathComponent(fileName)
        else {
            return
        }
        do {
            let data = try jsonEncoder.encode(items)
            try data.write(to: fileURL, options: [])
        } catch {
            LogError("Error saving items of type \(type) to file \(fileURL)", error: error)
        }
    }
    
    private func loadItemsFromDocuments() -> [T]? {
        guard let fileURL = documentsDirectoryURL?.appendingPathComponent(fileName)
        else {
            return nil
        }
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            return try loadItemsFromFile(fileURL)
        } catch let error {
            LogError("Error loading items of type \(type) from file \(fileURL)", error: error)
            return nil
        }
    }
    
    private func loadItemsFromBundle() -> [T]? {
        let fileURL: URL = bundleURL.appendingPathComponent(fileName)
        do {
            return try loadItemsFromFile(fileURL)
        } catch let error {
            LogError("Error loading items of type \(type) from file \(fileURL)", error: error)
            return nil
        }
    }
    
    private func loadItemFromBundle() throws -> T {
        let fileURL: URL = bundleURL.appendingPathComponent(fileName)
        return try loadItemFromFile(fileURL)
    }

    private func loadItemsFromFile(_ fileURL: URL) throws -> [T] {
        let jsonData = try Data(contentsOf: fileURL, options: [])
        let queries = try jsonDecoder.decode([T].self, from: jsonData)
        return queries
    }
    
    private func loadItemFromFile(_ fileURL: URL) throws -> T {
        let jsonData = try Data(contentsOf: fileURL, options: [])
        let queries = try jsonDecoder.decode(T.self, from: jsonData)
        return queries
    }
    
    var documentsDirectoryURL: URL? = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    var bundleURL: URL = Bundle.main.bundleURL

}

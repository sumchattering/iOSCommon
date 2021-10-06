//
//  NSUserDefaultsExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/6/21.
//

import Foundation

public extension UserDefaults {

    func setCustomObject<T: Codable>(object: T, forKey: String) {
        do {
            let jsonData = try JSONEncoder().encode(object)
            set(jsonData, forKey: forKey)
        } catch let error {
            LogError("Error saving custom object", error: error)
        }
    }

    func getCustomObject<T: Codable>(objectType: T.Type, forKey: String) -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(objectType, from: result)
        } catch let error {
            LogError("Error loading custom object", error: error)
            removeObject(forKey: forKey)
            return nil
        }
    }
}

//
//  ArrayExtensions.swift
//  Inter
//
//  Created by Sumeru Chatterjee on 10/8/21.
//

import Foundation

extension Array {
    init(repeating: [Element], count: Int) {
        self.init([[Element]](repeating: repeating, count: count).flatMap{$0})
    }
    
    func repeated(count: Int) -> [Element] {
        return [Element](repeating: self, count: count)
    }
}

//
//  StringExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/8/21.
//

import Foundation

extension String {
    func dropSuffixCaseInsensitive(_ suffix: String) -> String {
        var resultString = self
        
        if hasSuffixCaseInsensitive(suffix) {
            resultString = resultString.dropLast(suffix.count).description
        }
        
        return resultString
    }
    
    func hasSuffixCaseInsensitive(_ suffix: String) -> Bool {
        let lowercased = self.lowercased()
        return lowercased.hasSuffix(suffix.lowercased())
    }
    
}

extension DefaultStringInterpolation {
    mutating func appendInterpolation<T>(_ optional: T?) {
        appendInterpolation(String(describing: optional))
    }
}

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}

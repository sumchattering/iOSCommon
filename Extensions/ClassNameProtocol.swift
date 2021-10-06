//
//  ClassNameProtocol.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/2/21.
//

import Foundation
import UIKit

public protocol ClassNameProtocol {
    
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

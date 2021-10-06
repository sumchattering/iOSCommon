//
//  LogCategory.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/7/21.
//

import Foundation

public enum LogCategory: Int {
    
    case defaultCategory // default log category
    case networking // for all network related logs
    case applifecycle // for all app lifecycle logs
    case event // for all app events such as going to a new page
    
    public var description: String {
        switch self {
        case .defaultCategory:
            return "Default"
        case .networking:
            return "Networking"
        case .applifecycle:
            return "AppLifecycle"
        case .event:
            return "Event"
        }
    }
}

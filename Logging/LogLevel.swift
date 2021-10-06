//
//  LogLevel.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/7/21.
//

import Foundation
import os

public enum LogLevel: Int {
    case debug // useful only during debugging, info is not sent to datadog
    case info // helpful but not essential for troubleshooting
    case notice // Essential for troubleshooting
    case error // Error during execution
    case fault // Bug in program
    
    public var osLogType: OSLogType {
        switch self {
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            return .info
        case .error:
            return .error
        case .fault:
            return .fault
        }
    }
}

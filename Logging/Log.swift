//
//  Log.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/7/21.
//

@inlinable
public func LogDebug(_ message: String, category: LogCategory = .defaultCategory, file: String = #file, line: UInt = #line) {
    Logger.log(message, level: .debug, category: category, file: file, line: line)
}

@inlinable
public func LogInfo(_ message: String, category: LogCategory = .defaultCategory, file: String = #file, line: UInt = #line) {
    Logger.log(message, level: .info, category: category, file: file, line: line)
}

@inlinable
public func LogNotice(_ message: String, category: LogCategory = .defaultCategory, file: String = #file, line: UInt = #line) {
    Logger.log(message, level: .notice, category: category, file: file, line: line)
}

@inlinable
public func LogError(_ message: String, category: LogCategory = .defaultCategory, error: Error? = nil, file: String = #file, line: UInt = #line) {
    Logger.log(message, level: .error, category: category, error: error, file: file, line: line)
}

@inlinable
public func LogFault(_ message: String, category: LogCategory = .defaultCategory, error: Error? = nil, file: String = #file, line: UInt = #line) {
    Logger.log(message, level: .fault, category: category, error: error, file: file, line: line)
}

public func LogInitialize() {
    Logger.initialize()
}

public func LogSetDataDogTag(key: String, value: String) {
    Logger.setDataDogTag(key: key, value: value)
}

public func LogRemoveDataDogTag(key: String) {
    Logger.removeDataDogTag(key: key)
}



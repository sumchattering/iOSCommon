//
//  Logger.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/7/21.
//


import Foundation
import Datadog
import os
import UIKit

public class Logger {
    
    public static let queue = DispatchQueue(label: "com.tradomate.Log")
    
    #if !RELEASE
    public static var osLogEnabled = true
    #else
    public static var osLogEnabled = false
    #endif
    
    #if DEBUG
    public static var osDebugLogEnabled = true
    #else
    public static var osDebugLogEnabled = false
    #endif
        
    public static var dataDogLoggingEnabled = false
    public static var dataDogLogger: DDLogger?
    
    public static func initialize() {
        if let clientToken = Config.dataDogClientToken() {
            setupDataDogLogging(clientToken: clientToken, environment: Config.envName(), serviceName: "ios-app")
        }
    }
    
    public static func setDataDogTag(key: String, value: String) {
        if dataDogLoggingEnabled {
            dataDogLogger?.addTag(withKey: key, value: value)
        }
    }
    
    public static func removeDataDogTag(key: String) {
        if dataDogLoggingEnabled {
            dataDogLogger?.remove(tag: key)
        }
    }
    
    public static func disableDataDogLogging() {
        dataDogLoggingEnabled = false
        dataDogLogger = nil
    }
    
    public static func setupDataDogLogging(clientToken: String, environment: String, serviceName: String) {
        
        Datadog.initialize(
            appContext: .init(),
            trackingConsent: .granted,
            configuration: Datadog.Configuration
                .builderUsing(clientToken: clientToken, environment: environment)
                .set(serviceName: serviceName)
                .enableTracing(false)
                .build()
        )
        
        Datadog.verbosityLevel = .error
        
        dataDogLogger = DDLogger.builder
            .sendNetworkInfo(true)
            .sendLogsToDatadog(true)
            .printLogsToConsole(false)
            .build()
        
        dataDogLogger?.addTag(withKey: "appsession", value: UUID().uuidString);
        
        dataDogLoggingEnabled = true
    }
        
    private(set) static var loggerMap = [LogCategory: OSLog]()
    
    public static func getLogger(category: LogCategory) -> OSLog {
        if let logger = loggerMap[category] {
            return logger
        } else {
            let logger = OSLog.init(subsystem: UIApplication.appIdentifier, category: category.description)
            loggerMap[category] = logger
            return logger
        }
    }
    
    @inlinable
    public static func log(_ message: String, level: LogLevel, category: LogCategory = .defaultCategory, error: Error? = nil, file: String, line: UInt) {
        
        queue.async {
            var message = message
            if let error = error {
                message = "\(message) \(error.localizedDescription) Details:\((error as NSError).description)"
            }
            
            if osLogEnabled {
                let logger = getLogger(category: category)
                let loglevel = level.osLogType
                if loglevel == .debug {
                    if osDebugLogEnabled {
                        os_log("%{private}@ (%s:%i)", log: logger, type: loglevel, message, (file as NSString).lastPathComponent, line)
                    }
                } else {
                    os_log("%{public}@ (%s:%i)", log: logger, type: loglevel, message, (file as NSString).lastPathComponent, line)
                }
            }
            
            if dataDogLoggingEnabled {
                let dataDogLogMessage = "[\(category.description)] \(message) (\((file as NSString).lastPathComponent):\(line))"
                let dataDogLogAttributes = ["category": category.description]
                switch level {
                case .debug:
                    break // debug logs not sent to datadog
                case .info:
                    dataDogLogger?.info(dataDogLogMessage, attributes: dataDogLogAttributes)
                case .notice:
                    dataDogLogger?.notice(dataDogLogMessage, attributes: dataDogLogAttributes)
                case .error:
                    dataDogLogger?.error(dataDogLogMessage, error: error, attributes: dataDogLogAttributes)
                case .fault:
                    dataDogLogger?.critical(dataDogLogMessage, error: error, attributes: dataDogLogAttributes)
                }
            }
        }
    }
}

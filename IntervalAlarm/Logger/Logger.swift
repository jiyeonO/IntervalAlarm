//
//  Logger.swift
//  IntervalAlarm
//
//  Created by 오지연 on 10/2/24.
//

import Foundation

public enum LogLevel: Int {
    case verbose
    case debug
    case info
    case warning
    case error
    
    var header: String {
        switch self {
        case .verbose:
            return "🟣 VERBOSE" // purple
        case .debug:
            return "🟢 DEBUG"   // green
        case .info:
            return "🔵 INFO"    // blue
        case .warning:
            return "🟡 WARNING" // yellow
        case .error:
            return "🔴 ERROR"   // red
        }
    }
}

public struct DLog {
    
    /// debug
    public static func d(_ message: Any, functionName: String = #function, file: String = #file, line: Int = #line) {
        log(.debug, file, line, functionName, message)
    }
    
    /// info
    public static func i(_ message: Any, functionName: String = #function, file: String = #file, line: Int = #line) {
        log(.info, file, line, functionName, message)
    }
    
    /// warning
    public static func w(_ message: Any, functionName: String = #function, file: String = #file, line: Int = #line) {
        log(.warning, file, line, functionName, message)
    }
    
    /// error
    public static func e(_ message: Any, functionName: String = #function, file: String = #file, line: Int = #line) {
        log(.error, file, line, functionName, message)
    }
    
    private static func log(_ level: LogLevel, _ file: String, _ line: Int, _ functionName: String, _ message: Any) {
        #if DEBUG
        print("\(String.timestamp()) \(level.header) [Main:\(Thread.isMainThread)] [\(file.components(separatedBy: "/").last ?? ""):\(line)] \(String(describing: functionName)) > \(message)")
        #endif
    }
    
}

fileprivate extension String {
    
    static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        let date = Date()
        return String(format: "%@", formatter.string(from: date))
    }
    
}

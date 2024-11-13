//
//  TimeRange.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/9/24.
//

import Foundation

enum DayTimeType {
    
    case AM
    case PM
    
}

extension DayTimeType {
    
    var title: String {
        switch self {
        case .AM:
            return "오전"
        case .PM:
            return "오후"
        }
    }
}

struct TimeRange {
    
    var dayTimeTypes: [DayTimeType] = [.AM, .PM]
    var hours: [Int] = Array(0...23)
    var minutes: [Int] = Array(0...59)
    
    var height: CGFloat {
        256
    }
    
}

extension TimeRange: Equatable { }

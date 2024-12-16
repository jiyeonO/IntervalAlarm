//
//  DayTimeType.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/9/24.
//

import SwiftUI

enum DayTimeType: Codable, CaseIterable {
    
    case AM
    case PM
    
}

extension DayTimeType {
    
    var title: String {
        switch self {
        case .AM:
            return String(localized: "AM")
        case .PM:
            return String(localized: "PM")
        }
    }
}

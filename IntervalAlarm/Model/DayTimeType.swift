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
    
    var title: LocalizedStringKey {
        switch self {
        case .AM:
            return "오전"
        case .PM:
            return "오후"
        }
    }
}

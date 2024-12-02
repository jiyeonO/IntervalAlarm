//
//  SnoozeModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/30/24.
//
import SwiftUI

enum IntervalType: Codable, CaseIterable, Equatable {
    
    case three
    case five
    case ten
    case custom(Int)
    
}

extension IntervalType {
    
    var title: String {
        switch self {
        case .custom(_):
            return "직접 설정"
        default:
            return "\(self.value)분"
        }
    }
    
    var value: Int {
        switch self {
        case .three:
            return 3
        case .five:
            return 5
        case .ten:
            return 10
        case .custom(let value):
            return value
        }
    }
    
}

extension IntervalType {
    
    static var allCases: [IntervalType] {
        return [.three, .five, .ten, .custom(0)]
    }
    
}

enum RepeatType: Int, Codable, CaseIterable {
    
    case three = 3
    case five = 5
    case infinity = 0
    
}

extension RepeatType {
    
    var title: LocalizedStringKey {
        switch self {
        case .infinity:
            return "계속 반복"
        default:
            return "\(self.rawValue)회"
        }
    }
    
    var description: String {
        switch self {
        case .infinity:
            return String(localized: "계속")
        default:
            return String(localized: "\(self.rawValue)회")
        }
    }
    
}

struct SnoozeModel: Codable {

    var isOn: Bool = false
    var interval: IntervalType = .five
    var `repeat`: RepeatType = .infinity
    
}

extension SnoozeModel {
    
    var displayTitle: LocalizedStringKey {
        return LocalizedStringKey("\(interval.title), \(`repeat`.description)")
    }
    
    var displayDescription: LocalizedStringKey {
        return LocalizedStringKey("\(interval.value)분 간격으로 \(`repeat`.description) 반복해요")
    }
    
}

extension SnoozeModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.interval == rhs.interval && lhs.repeat == rhs.repeat
    }
    
}

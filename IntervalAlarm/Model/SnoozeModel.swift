//
//  SnoozeModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/30/24.
//
import SwiftUI

enum IntervalType: Codable, CaseIterable, Hashable {
    
    case three
    case five
    case ten
    case custom(Int)
    
}

extension IntervalType {
    
    var title: String {
        switch self {
        case .custom(_):
            return String(localized: "Custom")
        default:
            return String(localized: "\(self.value) minutes")
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
            return "infinity"
        default:
            return "\(self.rawValue) times"
        }
    }
    
    var description: String {
        switch self {
        case .infinity:
            return String(localized: "continuously")
        default:
            return String(localized: "\(self.rawValue) times")
        }
    }
    
}

struct SnoozeModel: Codable {

    var isOn: Bool = true
    var interval: IntervalType = .five
    var `repeat`: RepeatType = .infinity
    
}

extension SnoozeModel {
    
    var displayTitle: LocalizedStringKey {
        LocalizedStringKey("\(interval.title), \(`repeat`.description)")
    }
    
    var displayDescription: LocalizedStringKey {
        isOn ? LocalizedStringKey("Repeats \(`repeat`.description) times with \(interval.value)-minute intervals") : "Alarm will ring once"
    }
    
    func isSelectedInterval(_ type: IntervalType) -> Bool {
        self.isOn && self.interval == type
    }
    
    func isSelectedRepeat(_ type: RepeatType) -> Bool {
        self.isOn && self.repeat == type
    }
    
}

extension SnoozeModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.interval == rhs.interval && lhs.repeat == rhs.repeat
    }
    
}

//
//  SnoozeModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/30/24.
//

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
            return "직접 설정"
        default:
            return self.value.toString + "분"
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
    
    var displayContent: String {
        "\(self.value)분"
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
    
    var title: String {
        switch self {
        case .infinity:
            return "계속 반복"
        default:
            return "\(self.rawValue)회"
        }
    }
    
}

struct SnoozeModel: Codable {

    var isOn: Bool = false
    var interval: IntervalType = .five
    var `repeat`: RepeatType = .infinity
    
}

extension SnoozeModel {
    
    var displayTitle: String {
        "\(interval.displayContent), \(`repeat`.title)"
    }
    
}

extension SnoozeModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.interval == rhs.interval && lhs.repeat == rhs.repeat
    }
    
}

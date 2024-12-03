//
//  AlarmModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/3/24.
//

import Foundation
import EventKit
import ComposableArchitecture

struct AlarmModel: Codable, Equatable {
    
    var id = UUID()

    var hour: String // in 12-Hour
    var minute: String
    var dayTime: DayTimeType
    
    var isOn: Bool
    
    var repeatWeekdays: [String]
    var snooze: SnoozeModel
    var sound: SoundModel
    
    init() {
        let hourValue = Calendar.current.component(.hour, from: Date())
        let isAfternoon = hourValue > 12

        self.id = UUID()
        self.hour = isAfternoon ? String(hourValue - 12) : hourValue.toString
        self.minute = Calendar.current.component(.minute, from: Date()).toString
        self.dayTime = isAfternoon ? .PM : .AM
        self.isOn = true
        self.repeatWeekdays = []
        self.snooze = .init()
        self.sound = .init()
    }
    
    init(hour: String, minute: String, dayTime: DayTimeType = .AM, isOn: Bool = true, repeatWeekdays: [String] = [], snooze: SnoozeModel = .init(), sound: SoundModel = .init()) {
        self.id = UUID()
        self.hour = hour
        self.minute = minute
        self.dayTime = dayTime
        self.isOn = isOn
        self.repeatWeekdays = repeatWeekdays
        self.snooze = snooze
        self.sound = sound
    }
}

extension AlarmModel {
    
    var uuidString: String {
        id.uuidString
    }
    
    var hourValueIn24: Int { // in 24-Hour
        dayTime == .AM ? hourValue : hourValue + 12
    }
    
    var hourValue: Int {
        hour.toInt
    }
    
    var minuteValue: Int {
        minute.toInt
    }
    
    var displayDayTime: String {
        dayTime.title
    }
    
    var displayTitle: String {
        "\(hour) : \(minute)"
    }
    
    var notificationTitle: String {
        "⏰ \(displayDayTime) : \(displayTitle)"
    }
    
    var repeatWeekdaysValue: [Int] {
        self.repeatWeekdays.compactMap {
            weekdaySymbols.firstIndex(of: $0)?.advanced(by: 1)
        }
    }
    
    var weekdaySymbols: [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.shortStandaloneWeekdaySymbols
    }
    
    
    var weekdayIds: [String] {
        if self.repeatWeekdaysValue.isEmpty {
            return [self.uuidString]
        } else {
            return self.repeatWeekdaysValue.map {
                "\(self.uuidString)-weekday-\($0)"
            }
        }
    }
}

extension AlarmModel {
    
    static var previewItems: IdentifiedArrayOf<Self> {
        [
            .init(hour: "6", minute: "23", dayTime: .AM, isOn: false),
            .init(hour: "4", minute: "43", dayTime: .PM, isOn: true)
        ]
    }
    
    static var previewItem: Self {
        .init(hour: "5", minute: "11")
    }
    
}

extension AlarmModel: Identifiable { }

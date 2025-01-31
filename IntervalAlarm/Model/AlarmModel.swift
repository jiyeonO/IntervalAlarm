//
//  AlarmModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/3/24.
//

import SwiftUI
import EventKit
import ComposableArchitecture

struct AlarmModel: Codable, Equatable {
    
    var id = UUID()

    var hour: String // in 12-Hour
    var minutes: String
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
        self.minutes = Calendar.current.component(.minute, from: Date()).toString
        self.dayTime = isAfternoon ? .PM : .AM
        self.isOn = true
        self.repeatWeekdays = []
        self.snooze = .init()
        self.sound = .init()
    }
    
    init(hour: String, minutes: String, dayTime: DayTimeType = .AM, isOn: Bool = true, repeatWeekdays: [String] = [], snooze: SnoozeModel = .init(), sound: SoundModel = .init()) {
        self.id = UUID()
        self.hour = hour
        self.minutes = minutes
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

    var displayMinutes: String {
        minutes.count == 1 ? "0" + minutes : minutes
    }
    
    var didCompletedEditingHour: Bool {
        !(hour.isEmpty || (hour.count < 2 && (hour.hasPrefix("0") || hour.hasPrefix("1"))))
    }
    
    var didCompletedEditingMinutes: Bool {
        minutes.count < 2 && (minutes.hasPrefix("6") || minutes.hasPrefix("7") || minutes.hasPrefix("8") || minutes.hasPrefix("9"))
    }
    
    var filteringHour: String {
        hour.filteredByRegex(by: .hours)
    }
    
    var filteringMinutes: String {
        let updateMinutes = minutes.filteredByRegex(by: .minutes)
        return didCompletedEditingMinutes ? "0" + updateMinutes : updateMinutes
    }
    
    var hourValueIn24: Int { // in 24-Hour
        dayTime == .AM ? hourValue : hourValue + 12
    }
    
    var hourValue: Int {
        hour.toInt
    }
    
    var minuteValue: Int {
        minutes.toInt
    }
    
    var displayDayTime: String {
        dayTime.title
    }
    
    var displayTitle: String {
        "\(hour) : \(minutes)"
    }
    
    var notificationTitle: String {
        "\(displayDayTime) \(displayTitle)"
    }
    
    var repeatWeekdaysValue: [Int] {
        self.repeatWeekdays.compactMap {
            weekdaySymbols.firstIndex(of: $0)?.advanced(by: 1)
        }
    }
    
    var weekdayIds: [String] {
        if self.repeatWeekdaysValue.isEmpty {
            return [self.uuidString]
        } else {
            return self.repeatWeekdaysValue.map {
                self.getNotificationIdentifier(for: $0)
            }
        }
    }
    
    func getNotificationIdentifier(for weekday: Int) -> String {
        "\(self.uuidString)-weekday-\(weekday)"
    }
    
}

extension AlarmModel {
    
    static var previewItems: IdentifiedArrayOf<Self> {
        [
            .init(hour: "6", minutes: "23", dayTime: .AM, isOn: false),
            .init(hour: "4", minutes: "43", dayTime: .PM, isOn: true)
        ]
    }
    
    static var previewItem: Self {
        .init(hour: "5", minutes: "11")
    }
    
}

extension AlarmModel: Identifiable { }

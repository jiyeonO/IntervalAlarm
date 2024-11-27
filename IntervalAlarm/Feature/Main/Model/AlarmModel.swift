//
//  AlarmModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/3/24.
//

import Foundation
import ComposableArchitecture

struct AlarmModel: Codable, Equatable {
    
    var id = UUID()
    
    var dayTime: DayTimeType = .AM
    var hour: String // in 12-Hour TODO: 현재 시간 셋팅.
    var minute: String
    
    var isOn: Bool = true
    var isRepeat: Bool = false
    
    // TODO: 간격, 반복, 사운드 등
    
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
    
}

extension AlarmModel {
    
    static var previewItems: IdentifiedArrayOf<Self> {
        [
            .init(dayTime: .AM, hour: "6", minute: "23", isOn: false),
            .init(dayTime: .PM, hour: "4", minute: "43", isOn: true)
        ]
    }
    
    static var previewItem: Self {
        .init(hour: "5", minute: "11")
    }
    
}

extension AlarmModel: Identifiable { }

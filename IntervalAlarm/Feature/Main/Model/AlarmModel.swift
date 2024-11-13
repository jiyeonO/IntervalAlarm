//
//  AlarmModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/3/24.
//

import Foundation
import ComposableArchitecture

struct AlarmModel {
    
    let id = UUID()
    
    var dayTime: DayTimeType = .AM
    var hour: String // TODO: 현재 시간 셋팅
    var minute: String
    
    var isOn: Bool = true
    var isRepeat: Bool = false
    
    // TODO: 간격, 반복, 사운드 등
    
}

extension AlarmModel {
    
    var title: String {
        hour + ":" + minute
    }
    
}

extension AlarmModel {
    
    static var previewItems: IdentifiedArrayOf<Self> {
        [
            .init(dayTime: .AM, hour: "6", minute: "23", isOn: false),
            .init(dayTime: .PM, hour: "16", minute: "43", isOn: true)
        ]
    }
    
    static var previewItem: Self {
        .init(hour: "5", minute: "11")
    }
    
}

extension AlarmModel: Equatable, Identifiable { }

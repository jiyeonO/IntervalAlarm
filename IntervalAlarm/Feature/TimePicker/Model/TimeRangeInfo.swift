//
//  CustomPickerInfo.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2/16/24.
//

import Foundation

struct TimeRangeInfo {
    
    let doneButtonAction: (() -> Void)?
    
    var hourRange: [Int] = Array(0...23)
    var minuteRange: [Int] = Array(0...59)
    
}

extension TimeRangeInfo {
    
    var height: CGFloat {
        256
    }

}

extension TimeRangeInfo {

    static let previewItem: Self = .init {
        print("did tap done button")
    }
    
}

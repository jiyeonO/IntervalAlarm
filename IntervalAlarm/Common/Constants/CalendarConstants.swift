//
//  CalendarConstants.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/5/24.
//
import Foundation

var weekdaySymbols: [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale.current
    return calendar.shortStandaloneWeekdaySymbols
}

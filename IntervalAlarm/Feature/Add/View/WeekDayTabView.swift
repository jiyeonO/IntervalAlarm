//
//  WeekDayTabView.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/2/24.
//

import SwiftUI
import ComposableArchitecture

struct WeekDayTabView: View {
        
    var store: StoreOf<AddAlarmFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 10) {
                Text(Constants.weekDayTitle)
                    .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                    .foregroundStyle(.grey100)
                
                HStack {
                    ForEach(store.alarm.weekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 13))
                            .foregroundStyle(store.alarm.repeatWeekdays.contains(day) ? .white100 : .grey100)
                            .padding(.horizontal, 13.5)
                            .padding(.vertical, 10.5)
                            .background(store.alarm.repeatWeekdays.contains(day) ? .grey100 : .white100)
                            .cornerRadius(8.0)
                            .onTapGesture {
                                store.send(.didTapRepeatDay(day))
                            }
                    }
                }
            }
        }
    }
    
}

private extension WeekDayTabView {
    
    enum Constants {
        static let weekDayTitle = "요일"
    }
    
}

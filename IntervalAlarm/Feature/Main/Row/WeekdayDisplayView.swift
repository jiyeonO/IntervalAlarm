//
//  WeekdayDisplayView.swift
//  IntervalAlarm
//
//  Created by Jiwon Yoon on 11/30/24.
//

import SwiftUI

struct WeekdayDisplayView: View {

    let selectedWeekdays: [String]

    var body: some View {
        HStack(spacing: 5.0) {
            ForEach(weekdaySymbols, id: \.self) { text in
                Circle()
                    .foregroundStyle(selectedWeekdays.contains(text) ? .grey20 : .white100)
                    .overlay {
                        Text("\(text)")
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 12.0))
                            .foregroundStyle(.grey70)
                    }
                    .frame(width: 32.0, height: 32.0)
            }
        }
    }

}

#Preview {
    WeekdayDisplayView(selectedWeekdays: ["일", "월", "화", "수", "목", "금", "토"])
}

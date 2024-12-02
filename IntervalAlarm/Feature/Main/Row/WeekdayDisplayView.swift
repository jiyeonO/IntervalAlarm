//
//  WeekdayDisplayView.swift
//  IntervalAlarm
//
//  Created by Jiwon Yoon on 11/30/24.
//

import SwiftUI

struct WeekdayDisplayView: View {

    let symbols: [String] // TODO: 반복 요일 UI 노출 설정
    
    var body: some View {
        HStack(spacing: 5.0) {
            ForEach(symbols, id: \.self) { text in
                Circle()
                    .foregroundStyle(.grey20)
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


extension WeekdayDisplayView {

    static var weekdaySymbols: [String] = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.veryShortWeekdaySymbols
    }()

}

#Preview {
    WeekdayDisplayView(symbols: ["일", "월", "화", "수", "목", "금", "토"])
}

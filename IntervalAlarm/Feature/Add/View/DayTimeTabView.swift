//
//  DayTimeTabView.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/2/24.
//
import SwiftUI
import ComposableArchitecture

struct DayTimeTabView: View {
        
    var store: StoreOf<AddAlarmFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Constants.dayTimeTitle)
                .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                .foregroundStyle(.grey100)
            
            HStack {
                ForEach(DayTimeType.allCases, id: \.self) { type in
                    Text(type.title)
                        .font(Fonts.Pretendard.medium.swiftUIFont(size: 18))
                        .foregroundStyle(store.alarm.dayTime == type ? .white100 : .grey100)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(store.alarm.dayTime == type ? .grey100 : .white100)
                        .cornerRadius(12.0)
                        .onTapGesture {
                            store.send(.setDayTime(type))
                        }
                }
            }
        }
    }
    
}

private extension DayTimeTabView {
    
    enum Constants {
        static let dayTimeTitle: String = "시간대"
    }
    
}

#Preview {
    DayTimeTabView(store: .init(initialState: AddAlarmFeature.State(), reducer: {
        AddAlarmFeature()
    }))
}

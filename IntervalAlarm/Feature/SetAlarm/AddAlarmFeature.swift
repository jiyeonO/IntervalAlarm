//
//  AddAlarmFeature.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddAlarmFeature {
    
    @ObservableState
    struct State: Equatable {
        var alarm: AlarmModel = .previewItem
        let range: TimeRange = .init()
    }
    
    enum Action: BindableAction {
        case setDayTime(DayTimeType)
        case setHour(String)
        case setMinute(String)
        case setRepeat(Bool)
        case saveAlarm(AlarmModel)
        
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setDayTime(type):
                state.alarm.dayTime = type
                return .none
            case let .setHour(hour):
                state.alarm.hour = hour
                return .none
            case let .setMinute(minute):
                state.alarm.minute = minute
                return .none
            case let .setRepeat(isRepeat):
                state.alarm.isRepeat = isRepeat
                return .none
            case .saveAlarm(_):
                return .none
            case .binding:
                return .none
            }
        }
    }
    
}

import SwiftUI

struct AddAlarmView: View {
    
    @Perception.Bindable var store: StoreOf<AddAlarmFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack {
                    CustomNavigationView(type: .save) {
                        store.send(.saveAlarm(store.alarm))
                    }
                    
                    HStack(alignment: .center) {
                        Picker("DayTime", selection: $store.alarm.dayTime.sending(\.setDayTime)) {
                            ForEach(store.range.dayTimeTypes, id: \.self) { type in
                                Text(type.title)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        
                        HStack {
                            TextField("Hour", text: $store.alarm.hour.sending(\.setHour))
                                .font(Fonts.Pretendard.bold.swiftUIFont(size: 48))
                                .keyboardType(.numberPad)
                            Text(":")
                            TextField("Minute", text: $store.alarm.minute.sending(\.setMinute))
                                .font(Fonts.Pretendard.bold.swiftUIFont(size: 48))
                                .keyboardType(.numberPad)
                        }
                        .frame(width: 150)
                    }
                    
                    
                    Spacer()
                    
                    Form {
                        Section("알람 설정") {
                            Toggle(isOn: $store.alarm.isRepeat.sending(\.setRepeat)) {
                                Text("다시 울림") // TODO: 간격 선택
                            }
                            Text("알람음 설정")
                            Text("진동 여부")
                        }
                    }
                }
            }
        }
    }

}

#Preview {
    AddAlarmView(store: Store(initialState: AddAlarmFeature.State(alarm: .previewItem), reducer: {
        AddAlarmFeature()
    }))
}


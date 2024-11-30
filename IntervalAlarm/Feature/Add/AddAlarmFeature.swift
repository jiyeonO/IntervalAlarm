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
        var alarm: AlarmModel = .init()
    }
    
    enum Action: BindableAction {
        case didTapBackButton
        case didTapSaveButton
        case setDayTime(DayTimeType)
        case setHour(String)
        case setMinute(String)
        case didToggleSnooze(Bool)
        case didToggleVibrate(Bool)
        case didToggleSound(Bool)
        case setRepeat(Bool) // TODO: 요일 반복
        case saveAlarm
        case setAlarmOn(AlarmModel)
        
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapBackButton:
                return .run { _ in await dismiss() }
            case .didTapSaveButton:
                return .send(.saveAlarm)
            case let .setDayTime(type):
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
                
                state.alarm.dayTime = type
                return .none
            case let .setHour(hour):
                state.alarm.hour = hour
                return .none
            case let .setMinute(minute):
                state.alarm.minute = minute
                return .none
            case let .didToggleSnooze(isOn):
                state.alarm.snooze.isOn = isOn
                return .none
            case let .didToggleVibrate(isOn):
                state.alarm.isVibrate = isOn
                return .none
            case let .didToggleSound(isOn):
                state.alarm.sound.isOn = isOn
                return .none
            case .setRepeat(_): // TODO
                return .none
            case .saveAlarm:
                userDefaultsClient.saveAlarm(state.alarm)
                return .concatenate(.send(.setAlarmOn(state.alarm)),
                                    .run { _ in await dismiss() })
            case .setAlarmOn(_):
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
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    CustomNavigationView(type: .save) {
                        store.send(.didTapBackButton)
                    } doneAction: {
                        store.send(.didTapSaveButton)
                    }
                    .padding(.bottom, -10)
                    
                    HStack(spacing: 30) {
                        TextField(store.alarm.hour, text: $store.alarm.hour.sending(\.setHour))
                            .keyboardType(.numberPad)
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 72))
                            .foregroundStyle(.grey100)
                            .multilineTextAlignment(.trailing)
                        Text(":")
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 72))
                            .foregroundStyle(.grey60)
                        TextField(store.alarm.minute, text: $store.alarm.minute.sending(\.setMinute))
                            .keyboardType(.numberPad)
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 72))
                            .foregroundStyle(.grey100)
                    }
                    .padding(30)
                    .background(.white100)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("시간대")
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
                    
                    VStack(alignment: .center, spacing: 10) {
                        Toggle(isOn: $store.alarm.snooze.isOn.sending(\.didToggleSnooze)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("다시 울림")
                                    .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                                    .foregroundStyle(.grey100)
                                Text(store.alarm.snooze.isOn ? store.alarm.snooze.displayTitle : "사용 안함")
                                    .font(Fonts.Pretendard.regular.swiftUIFont(size: 13))
                                    .foregroundStyle(.grey80)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .grey90))
                        .padding(20)
                        .background(.white100)
                        .cornerRadius(12)
                        
                        Toggle(isOn: $store.alarm.isVibrate.sending(\.didToggleVibrate)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("진동")
                                    .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                                    .foregroundStyle(.grey100)
                                Text(store.alarm.isVibrate ? "사용함" : "사용 안함")
                                    .font(Fonts.Pretendard.regular.swiftUIFont(size: 13))
                                    .foregroundStyle(.grey80)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .grey90))
                        .padding(20)
                        .background(.white100)
                        .cornerRadius(12)
                        
                        Toggle(isOn: $store.alarm.sound.isOn.sending(\.didToggleSound)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("알람음 설정")
                                    .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                                    .foregroundStyle(.grey100)
                                Text(store.alarm.sound.isOn ? store.alarm.sound.title : "사용 안함")
                                    .font(Fonts.Pretendard.regular.swiftUIFont(size: 13))
                                    .foregroundStyle(.grey80)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .grey90))
                        .padding(20)
                        .background(.white100)
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                    
                    Images.logo.swiftUIImage
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.immediately)
            .background(.grey20)
        }
    }

}

#Preview {
    AddAlarmView(store: Store(initialState: AddAlarmFeature.State(alarm: .previewItem), reducer: {
        AddAlarmFeature()
    }))
}

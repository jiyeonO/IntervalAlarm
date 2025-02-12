//
//  AddAlarmFeature.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/7/24.
//

import Foundation
import ComposableArchitecture

enum AddAlarmEntryType {
    case add
    case modify
}

@Reducer
struct AddAlarmFeature {
    
    @ObservableState
    struct State: Equatable {
        enum FocusField: Hashable {
            case hour
            case minute
        }
        
        var isSaveButtonEnabled: Bool {
            !self.alarm.hour.isEmpty && !self.alarm.minutes.isEmpty
        }
        
        var focusedField: FocusField?
        
        let entryType: AddAlarmEntryType
        var alarm: AlarmModel
        
        @Presents var snoozeOptionState: SnoozeOptionFeature.State?

        init(entryType: AddAlarmEntryType = .add, alarm: AlarmModel = .init()) {
            self.entryType = entryType
            self.alarm = alarm
        }

    }
    
    enum Action: BindableAction {
        case onAppear
        case setInitFocus
        case didTapBackButton
        case didTapSaveButton
        case setDayTime(DayTimeType)
        case setHour(String)
        case setMinutes(String)
        case didToggleSnooze
        case didToggleSound
        case didTapRepeatDay(String)
        case saveAlarm
        case setAlarmOn(AlarmModel)
        case modifyAlarm(AlarmModel)
        case toSnoozeOption
        case filteringHour
        case filteringMinute
        case focusOut
        case setDisplayMinute
        case binding(BindingAction<State>)
        case snoozeOptionAction(PresentationAction<SnoozeOptionFeature.Action>)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(.send(.setDisplayMinute),
                              .run(operation: { send in
                                  try await clock.sleep(for: .seconds(0.1))
                                  await send(.setInitFocus)
                              }))
            case .setInitFocus:
                state.focusedField = .hour
                return .none
            case .didTapBackButton:
                return .run { _ in await dismiss() }
            case .didTapSaveButton:
                return .concatenate(.send(.setDisplayMinute),
                                    .send(.saveAlarm))
            case let .setDayTime(type):
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
                
                state.alarm.dayTime = type
                return .none
            case let .setHour(hour):
                state.alarm.hour = hour
                return .none
            case let .setMinutes(minutes):
                state.alarm.minutes = minutes
                return .none
            case .didToggleSnooze:
                state.alarm.snooze.isOn.toggle()
                return .none
            case .didToggleSound:
                state.alarm.sound.isOn.toggle()
                return .none
            case let .didTapRepeatDay(day):
                if state.alarm.repeatWeekdays.contains(day) {
                    state.alarm.repeatWeekdays.removeAll { $0 == day }
                } else {
                    state.alarm.repeatWeekdays.append(day)
                }
                return .none
            case .saveAlarm:
                if state.entryType == .add  {
                    userDefaultsClient.saveAlarm(state.alarm)
                    
                    return .concatenate(.send(.setAlarmOn(state.alarm)),
                                        .run { _ in await dismiss() })
                } else {
                    userDefaultsClient.modifyAlarm(state.alarm)
                    
                    return .concatenate(.send(.modifyAlarm(state.alarm)),
                                        .run { _ in await dismiss() })
                }
            case .toSnoozeOption:
                state.snoozeOptionState = SnoozeOptionFeature.State(model: state.alarm.snooze)
                return .none
            case .snoozeOptionAction(.presented(.updateSnoozeModel(let model))):
                state.alarm.snooze = model
                return .none
            case .filteringHour:
                state.alarm.hour = state.alarm.filteringHour
                
                if state.alarm.didCompletedEditingHour {
                    state.focusedField = .minute
                }
                return .none
            case .filteringMinute:
                state.alarm.minutes = state.alarm.filteringMinutes
                return .none
            case .focusOut:
                state.focusedField = nil
                return .send(.setDisplayMinute)
            case .setDisplayMinute:
                state.alarm.minutes = state.alarm.displayMinutes
                return .none
            case .setAlarmOn(_):
                return .none
            case .modifyAlarm(_):
                return .none
            case .binding:
                return .none
            case .snoozeOptionAction:
                return .none
            }
        }
        .ifLet(\.$snoozeOptionState, action: \.snoozeOptionAction) {
            SnoozeOptionFeature()
        }
    }
    
}

import SwiftUI

struct AddAlarmView: View {
    
    @Perception.Bindable var store: StoreOf<AddAlarmFeature>
    
    @FocusState var focusedField: AddAlarmFeature.State.FocusField?
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    CustomNavigationView(type: .save, doneEnabled: store.isSaveButtonEnabled) {
                        store.send(.didTapBackButton)
                    } doneAction: {
                        store.send(.didTapSaveButton)
                    }
                    .padding(.bottom, -10)
                    
                    HStack(spacing: 30) {
                        TextField(store.alarm.hour, text: $store.alarm.hour.sending(\.setHour))
                            .focused($focusedField, equals: .hour)
                            .keyboardType(.numberPad)
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 72))
                            .foregroundStyle(.grey100)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: store.alarm.hour) { _ in
                                store.send(.filteringHour)
                            }
                        Text(":")
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 72))
                            .foregroundStyle(.grey60)
                        TextField(store.alarm.minutes, text: $store.alarm.minutes.sending(\.setMinutes))
                            .focused($focusedField, equals: .minute)
                            .keyboardType(.numberPad)
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 72))
                            .foregroundStyle(.grey100)
                            .onChange(of: store.alarm.minutes) { _ in
                                store.send(.filteringMinute)
                            }
                    }
                    .bind($store.focusedField, to: $focusedField)
                    .padding(30)
                    .background(.white100)
                    .cornerRadius(12)
                    
                    DayTimeTabView(store: store)
                    
                    WeekDayTabView(store: store)
                    
                    AlarmOptionsView(store: store)
                    
                    Spacer()
                    
                    Images.logo.swiftUIImage
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(20)
            }
            .onAppear {
                store.send(.onAppear)
            }
            .onTapGesture {
                store.send(.focusOut)
            }
            .sheet(item: $store.scope(state: \.snoozeOptionState, action: \.snoozeOptionAction)) { store in
                WithPerceptionTracking {
                    SnoozeOptionView(store: store)
                        .measureHeight()
                }
            }
            .swipeToDismiss {
                store.send(.didTapBackButton)
            }
            .toolbar(.hidden, for: .navigationBar)
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

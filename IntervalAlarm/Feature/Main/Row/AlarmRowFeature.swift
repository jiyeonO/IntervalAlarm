//
//  AlarmRowFeature.swift
//  IntervalAlarm
//
//  Created by 오지연 on 8/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AlarmRowFeature {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: UUID
        var alarm: AlarmModel = .previewItem
        
        @Presents var alert: AlertState<Action.Alert>?
        
        init(model: AlarmModel) {
            self.id = model.id
            self.alarm = model
        }
    }
    
    enum Action: BindableAction { // TODO: Nested Protocol 적용
        case didTapAlarm
        case toModifyAlarm
        case didTapToggle(Bool)
        case setAlarmOn
        case setAlarmOff
        
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        @CasePathable
        enum Alert: Equatable {
            case toSetting
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapAlarm:
                return .send(.toModifyAlarm)
            case let .didTapToggle(isOn):
                state.alarm.isOn = isOn
                return isOn ? .send(.setAlarmOn) : .send(.setAlarmOff)
            case .toModifyAlarm:
                return .none
            case .setAlarmOn:
                return .none
            case .setAlarmOff:
                return .none
            case .alert:
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
    
}

import SwiftUI

struct AlarmRowView: View {
    
    @Perception.Bindable var store: StoreOf<AlarmRowFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(spacing: 4.0) {
                                Text(store.alarm.displayTitle)
                                    .font(Fonts.Pretendard.bold.swiftUIFont(size: 28.0))
                                    .foregroundStyle(.grey90)

                                Text(store.alarm.dayTime.title)
                                    .font(Fonts.Pretendard.bold.swiftUIFont(size: 20.0))
                                    .foregroundStyle(.grey70)
                            }
                            Text("10분 간격으로 3회 반복해요")
                                .foregroundStyle(.grey80)
                        }
                        Spacer()
                        Toggle("", isOn: $store.alarm.isOn.sending(\.didTapToggle))
                            .toggleStyle(SwitchToggleStyle(tint: Colors.grey90.swiftUIColor))
                            .labelsHidden()
                    }

                    WeekdayDisplayView(selectedWeekdays: store.alarm.repeatWeekdays)
                        .padding(.top, 20.0)
                }
                .padding(20.0)
                .background(.white100)
            }
            .clipShape(.rect(cornerRadius: 12.0))
            .padding(.horizontal, 20.0)
            .padding(.vertical, 10.0)
            .onTapGesture {
                store.send(.didTapAlarm)
            }
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
    
}

#Preview {
    AlarmRowView(store: Store(initialState: AlarmRowFeature.State(model: AlarmModel.previewItem), reducer: {
        AlarmRowFeature()
    }))
}


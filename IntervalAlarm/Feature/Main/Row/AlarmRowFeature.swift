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
        case toAlarmDetail
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
                return .send(.toAlarmDetail)
            case let .didTapToggle(isOn):
                state.alarm.isOn = isOn
                return isOn ? .send(.setAlarmOn) : .send(.setAlarmOff)
            case .toAlarmDetail:
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
            HStack {
                Toggle(isOn: $store.alarm.isOn.sending(\.didTapToggle), label: {
                    HStack {
                        Text(store.alarm.displayDayTime)
                            .font(Fonts.Pretendard.regular.swiftUIFont(size: 20))
                        Text(store.alarm.displayTitle)
                            .font(Fonts.Pretendard.semiBold.swiftUIFont(size: 42))
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("알람 타이틀")
                                .font(Fonts.Pretendard.regular.swiftUIFont(size: 14))
                            Text("반복, 5분")
                                .font(Fonts.Pretendard.regular.swiftUIFont(size: 14))
                        }
                    }
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.yellow))
            }
            .frame(height: 75)
            .padding(.horizontal, 20)
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


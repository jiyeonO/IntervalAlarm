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
        
        init(model: AlarmModel) {
            self.id = model.id
            self.alarm = model
        }
    }
    
    enum Action: BindableAction {
        case setToggleOn(Bool)
        
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setToggleOn(isOn):
                state.alarm.isOn = isOn
                return .none
            case .binding:
                return .none
            }
        }
    }
    
}

import SwiftUI

struct AlarmRowView: View {
    
    @Perception.Bindable var store: StoreOf<AlarmRowFeature>
    
    var body: some View {
        WithPerceptionTracking {
            HStack {
                Toggle(isOn: $store.alarm.isOn.sending(\.setToggleOn), label: {
                    HStack {
                        Text(store.alarm.dayTime.title)
                            .font(Fonts.Pretendard.regular.swiftUIFont(size: 20))
                        Text(store.alarm.title)
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
        }
    }
    
}

#Preview {
    AlarmRowView(store: Store(initialState: AlarmRowFeature.State(model: AlarmModel.previewItem), reducer: {
        AlarmRowFeature()
    }))
}


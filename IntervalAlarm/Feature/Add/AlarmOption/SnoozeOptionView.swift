//
//  SnoozeOptionView.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/3/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SnoozeOptionFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case custom(CustomInputFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var model: SnoozeModel
        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction {
        case didSwipeToggle(Bool)
        case didTapInterval(IntervalType)
        case didTapRepeat(RepeatType)
        case updateSnoozeModel(SnoozeModel)
        case addDestination
        
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didSwipeToggle(let isOn):
                state.model.isOn = isOn
                return .send(.updateSnoozeModel(state.model))
            case .didTapInterval(let type):
                state.model.interval = type
                switch type {
                case .custom:
                    return .concatenate(
                        .send(.updateSnoozeModel(state.model)),
                        .send(.addDestination)
                    )
                default:
                    return .send(.updateSnoozeModel(state.model))
                }
            case .didTapRepeat(let type):
                state.model.repeat = type
                state.path.append(.custom(CustomInputFeature.State()))
                return .send(.updateSnoozeModel(state.model))
            case .updateSnoozeModel:
                return .none
            case .binding:
                return .none
            case .path:
                return .none
            case .addDestination:
                state.path.append(.custom(CustomInputFeature.State()))
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

struct SnoozeOptionView: View {
    
    @Perception.Bindable var store: StoreOf<SnoozeOptionFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Toggle(isOn: $store.model.isOn.sending(\.didSwipeToggle)) {
                            Text("Ring Again")
                                .font(Fonts.Pretendard.bold.swiftUIFont(size: 24))
                                .foregroundStyle(.grey100)
                                .frame(height: 48)
                        }
                        .tint(.grey90)
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Interval")
                                .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                                .foregroundStyle(.grey100)
                            Spacer()
                        }
                        
                        VStack(spacing: 0) {
                            ForEach(IntervalType.allCases, id: \.self) { type in
                                HStack {
                                    Text(type.title)
                                        .font(Fonts.Pretendard.regular.swiftUIFont(size: 16))
                                        .foregroundStyle(.grey100)
                                        .frame(height: 56)
                                    
                                    Spacer()
                                    
                                    if store.model.isSelectedInterval(type) {
                                        Images.icCheck.swiftUIImage
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                .padding(16)
                                .frame(height: 56)
                                .background(store.model.isSelectedInterval(type) ? .grey20 : .clear)
                                .cornerRadius(12.0)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.send(.didTapInterval(type))
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Repeat")
                                .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                                .foregroundStyle(.grey100)
                            Spacer()
                        }
                        
                        VStack(spacing: 0) {
                            ForEach(RepeatType.allCases, id: \.self) { type in
                                HStack {
                                    Text(type.title)
                                        .font(Fonts.Pretendard.regular.swiftUIFont(size: 16))
                                        .foregroundStyle(.grey100)
                                        .frame(height: 56)
                                    
                                    Spacer()
                                    
                                    if store.model.isSelectedRepeat(type) {
                                        Images.icCheck.swiftUIImage
                                    }
                                }
                                .padding(16)
                                .frame(height: 56)
                                .background(store.model.isSelectedRepeat(type) ? .grey20 : .clear)
                                .cornerRadius(12.0)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.send(.didTapRepeat(type))
                                }
                            }
                        }
                    }
                }
                .padding(30)
            } destination: { store in
                WithPerceptionTracking {
                    switch store.case {
                    case let .custom(store):
                        CustomInputView(store: store)
                    }                    
                }
            }
        }
    }
}

#Preview {
    SnoozeOptionView(store: Store(initialState: SnoozeOptionFeature.State(model: .init()), reducer: {
        SnoozeOptionFeature()
    }))
}

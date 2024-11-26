//
//  MainFeature.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case detail(DetailFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var myAlarms: IdentifiedArrayOf<AlarmModel> = []
        
        var path = StackState<Path.State>()
        @Presents var addAlarmState: AddAlarmFeature.State?
    }
    
    enum Action {
        case onAppear
        case didTapAddButton
        case didTapAlarm(AlarmModel)
        case didSwipeDelete(IndexSet)
        
        case path(StackActionOf<Path>)
        case addAlarmAction(PresentationAction<AddAlarmFeature.Action>)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.myAlarms = userDefaultsClient.loadAlarms()
                return .none
            case .didTapAddButton:
                state.addAlarmState = AddAlarmFeature.State()
                return .none
            case .didTapAlarm(let alarm):
                state.path.append(.detail(DetailFeature.State(alarm: alarm)))
                return .none
            case .didSwipeDelete(let indexSet):
                state.myAlarms.remove(atOffsets: indexSet)
                userDefaultsClient.saveAlarms(state.myAlarms)
                return .none
            case let .path(action):
                switch action {
                case .element(id: _, action: .detail(.onDisappear)):
                    return .none
                default:
                    return .none
                }
            case .addAlarmAction(.presented(.saveAlarm)):
                return .send(.onAppear)
            case .addAlarmAction:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$addAlarmState, action: \.addAlarmAction) {
            AddAlarmFeature()
        }
    }
    
}

import SwiftUI

struct MainView: View {
    
    @Perception.Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                List {
                    ForEach(store.myAlarms) { alarm in
                        VStack {
                            AlarmRowView(store: Store(initialState: AlarmRowFeature.State(model: alarm)) {
                                AlarmRowFeature()
                            })
                            CustomDivider()
                        }
                        .noneSeperator()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.didTapAlarm(alarm))
                        }
                    }
                    .onDelete {
                        store.send(.didSwipeDelete($0))
                    }
                    
                }
                .listStyle(.plain)
                .navigationTitle("알람")
                .toolbar {
                    ToolbarItem {
                        CustomNavigationView(type: .add) {
                            store.send(.didTapAddButton)
                        }
                    }
                }
            } destination: { store in
                WithPerceptionTracking {
                    switch store.case {
                    case let .detail(store):
                        DetailView(store: store)
                    }
                }
            }
            .sheet(item: $store.scope(state: \.addAlarmState, action: \.addAlarmAction)) { store in
                AddAlarmView(store: store)
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
}

#Preview {
    MainView(store: Store(initialState: MainFeature.State(myAlarms: AlarmModel.previewItems), reducer: {
        MainFeature()
    }))
}


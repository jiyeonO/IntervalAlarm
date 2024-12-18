//
//  MainRouteFeature.swift
//  IntervalAlarm
//
//  Created by Davidyoon on 12/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainRouteFeature {
    
    @ObservableState
    enum State: Equatable {
        case snooze(SnoozeFeature.State)
        case main(MainFeature.State)
        case empty(EmptyListFeature.State)
    }
    
    enum Action {
        case onAppear
        case onSnooze
        case snooze(SnoozeFeature.Action)
        case main(MainFeature.Action)
        case empty(EmptyListFeature.Action)
        case switchStore
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .snooze(.switchStore), .empty(.switchStore), .main(.switchStore):
                return .send(.switchStore)
            case .onSnooze:
                state = .snooze(SnoozeFeature.State())
                return .none
            case .switchStore:
                if userDefaultsClient.loadAlarms().isEmpty {
                    state = .empty(EmptyListFeature.State())
                } else {
                    state = .main(MainFeature.State())
                }
                return .none
            case .snooze:
                return .none
            case .main:
                return .none
            case .empty:
                return .none
            }
        }
        .ifCaseLet(\.snooze, action: \.snooze) {
            SnoozeFeature()
        }
        .ifCaseLet(\.empty, action: \.empty) {
            EmptyListFeature()
        }
        .ifCaseLet(\.main, action: \.main) {
            MainFeature()
        }
    }
    
}

import SwiftUI
struct MainRouteView: View {
    
    let store: StoreOf<MainRouteFeature>
    
    var body: some View {
        WithPerceptionTracking {
            switch store.state {
            case .snooze:
                if let store = store.scope(state: \.snooze, action: \.snooze) {
                    SnoozeView(store: store)
                }
            case .empty:
                if let store = store.scope(state: \.empty, action: \.empty) {
                    EmptyListView(store: store)
                }
            case .main:
                if let store = store.scope(state: \.main, action: \.main) {
                    MainView(store: store)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(NotificationCenterIdentifier.onSnoozeAlarm))) { _ in
            store.send(.onSnooze)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
}

#Preview {
    MainRouteView(store: Store(initialState: MainRouteFeature.State.empty(EmptyListFeature.State())) {
        MainRouteFeature()
    })
}

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
        case main(MainFeature.State)
        case empty(EmptyListFeature.State)
    }
    
    enum Action {
        case main(MainFeature.Action)
        case empty(EmptyListFeature.Action)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .main:
                return .none
            case .empty(.onAppear):
                if !userDefaultsClient.loadAlarms().isEmpty {
                    state = .main(MainFeature.State())
                }
                
                return .none
            case .empty:
                return .none
            }
        }
    }
    
}

import SwiftUI
struct MainRouteView: View {
    
    let store: StoreOf<MainRouteFeature>
    
    var body: some View {
        WithPerceptionTracking {
            switch store.state {
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
    }
    
}

#Preview {
    MainRouteView(store: Store(initialState: MainRouteFeature.State.empty(EmptyListFeature.State())) {
        MainRouteFeature()
    })
}

//
//  DetailFeature.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/21/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailFeature {
    
    @ObservableState
    struct State: Equatable {
        var alarm: AlarmModel
    }
    
    enum Action {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
    
}

import SwiftUI

struct DetailView: View {
    
    let store: StoreOf<DetailFeature>

    var body: some View {
        WithPerceptionTracking {
            Text(store.alarm.displayTitle)
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }
}

#Preview {
    DetailView(store: Store(initialState: DetailFeature.State(alarm: AlarmModel.previewItem), reducer: {
        DetailFeature()
    }))
}


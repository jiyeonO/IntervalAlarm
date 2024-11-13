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
        var alarm: AlarmModel?
    }
    
    enum Action {
        case onDisappear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .none
            }
        }
    }
    
}

import SwiftUI

struct DetailView: View {
    
    let store: StoreOf<DetailFeature>

    var body: some View {
        Text("Hello, \(String(describing: store.alarm?.title))")
            .onDisappear {
                store.send(.onDisappear)
            }
    }
}

#Preview {
    DetailView(store: Store(initialState: DetailFeature.State(alarm: AlarmModel.previewItem), reducer: {
        DetailFeature()
    }))
}


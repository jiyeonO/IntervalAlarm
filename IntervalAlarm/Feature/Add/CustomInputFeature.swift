//
//  CustomInputFeature.swift
//  IntervalAlarm
//
//  Created by Davidyoon on 12/5/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CustomInputFeature {
    
    @ObservableState
    struct State: Equatable {
        var minutes: String = ""
    }
    
    enum Action {
        case didTapBack
        case setMinutes(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapBack:
                return .run { _ in await dismiss() }
            case .setMinutes(let minutes):
                state.minutes = minutes
                return .none
            }
        }
    }
    
}

import SwiftUI
struct CustomInputView: View {
    
    @Perception.Bindable var store: StoreOf<CustomInputFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading) {
                HStack(spacing: 0.0) {
                    Button(action: {
                        store.send(.didTapBack)
                    }, label: {
                        Images.icArrowBack24.swiftUIImage
                    })
                    .padding(.horizontal, 8.0)
                    Text("Manual Settings")
                        .font(Fonts.Pretendard.bold.swiftUIFont(size: 24.0))
                        .foregroundStyle(.black100)
                        .padding(.vertical, 8.0)
                    Spacer()
                }
                .padding(.horizontal, 20.0)
                .padding(.top, 30.0)
                
                HStack {
                    Spacer()
                    TextField("분", text: $store.minutes.sending(\.setMinutes))
                        .font(Fonts.Pretendard.medium.swiftUIFont(size: 72.0))
                        .keyboardType(.numberPad)
                        .frame(height: 86.0)
                        .padding(.top, 80.0)
                        .fixedSize()
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
}

#Preview {
    
    CustomInputView(store: Store(initialState: CustomInputFeature.State()) {
        CustomInputFeature()
    })
    
}

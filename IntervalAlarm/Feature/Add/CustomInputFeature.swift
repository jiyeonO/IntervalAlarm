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
        var focusedField: FieldType? = .minutes
        
        enum FieldType: Hashable {
            case minutes
        }
    }
    
    enum Action: BindableAction {
        case didTapBack
        case setMinutes(String)
        case binding(BindingAction<State>)
        case filteringMinute(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .didTapBack:
                return .run { _ in await dismiss() }
            case .setMinutes(let minutes):
                state.minutes = minutes
                return .none
            case .binding:
                return .none
            case .filteringMinute(let minute):
                state.minutes = minute.filteredByRegex(by: .intervalMinutes)
                return .none
            }
        }
    }
    
}

import SwiftUI
struct CustomInputView: View {
    
    @Perception.Bindable var store: StoreOf<CustomInputFeature>
    @FocusState var focusedField: CustomInputFeature.State.FieldType?
    
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
                
                HStack(alignment: .center) {
                    Spacer()
                    TextField("0", text: $store.minutes.sending(\.setMinutes))
                        .font(Fonts.Pretendard.medium.swiftUIFont(size: 72.0))
                        .focused($focusedField, equals: .minutes)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                        .frame(height: 86.0)
                        .fixedSize()
                        .onChange(of: store.minutes) { newValue in
                            store.send(.filteringMinute(newValue))
                        }
                    Text("분")
                        .font(Fonts.Pretendard.medium.swiftUIFont(size: 72.0))
                        .foregroundStyle(.grey70)
                    Spacer()
                }
                .padding(.top, 80.0)
                Spacer()
            }
            .bind($store.focusedField, to: $focusedField)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
}

#Preview {
    
    CustomInputView(store: Store(initialState: CustomInputFeature.State()) {
        CustomInputFeature()
    })
    
}

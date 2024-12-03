//
//  EmptyListFeature.swift
//  IntervalAlarm
//
//  Created by Davidyoon on 12/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EmptyListFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var addAlarmState: AddAlarmFeature.State?
    }
    
    enum Action {
        case onAppear
        case didTapAddButton
        case addAlarmAction(PresentationAction<AddAlarmFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .didTapAddButton:
                state.addAlarmState = AddAlarmFeature.State()
                return .none
            case .addAlarmAction:
                return .none
            }
        }
        .ifLet(\.$addAlarmState, action: \.addAlarmAction) {
            AddAlarmFeature()
        }
    }
    
}

import SwiftUI
struct EmptyListView: View {
    
    @Perception.Bindable var store: StoreOf<EmptyListFeature>
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Images.imgBell.swiftUIImage
                Spacer()
            }
            .background(.grey20)
            .padding(.top, 145.6)
            
            Text("알람이 없어요")
                .font(Fonts.Pretendard.bold.swiftUIFont(size: 24.0))
                .foregroundStyle(.grey60)
            Text("알람을 지금 바로 추가해 보세요!")
                .font(Fonts.Pretendard.regular.swiftUIFont(size: 16.0))
                .foregroundStyle(.grey60)
                .padding(.top, 1.0)
            
            Button(action: {
                store.send(.didTapAddButton)
            }, label: {
                HStack(alignment: .center) {
                    Images.icAdd24.swiftUIImage
                    Text("알람 추가하기")
                        .font(Fonts.Pretendard.semiBold.swiftUIFont(size: 16.0))
                        .foregroundStyle(.black100)
                }
                .frame(width: 200.0)
                .padding(.vertical, 16.0)
                .padding(.horizontal, 8.0)
                .background(.white100)
                .clipShape(.rect(cornerRadius: 12.0))
            })
            .padding(.top, 40.0)
            
            
            Spacer()
            
            Images.logo.swiftUIImage
        }
        .background(.grey20)
        .sheet(item: $store.scope(state: \.addAlarmState, action: \.addAlarmAction)) { store in
            WithPerceptionTracking {
                AddAlarmView(store: store)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
}

#Preview {
    EmptyListView(store: Store(initialState: EmptyListFeature.State()) {
        EmptyListFeature()
    })
}

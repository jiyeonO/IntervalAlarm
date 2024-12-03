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
    
    @ObservableState
    struct State: Equatable {
        let model: SnoozeModel
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct SnoozeOptionView: View {
    
    var store: StoreOf<SnoozeOptionFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 20) {
                Text("다시 울림")
                    .font(Fonts.Pretendard.bold.swiftUIFont(size: 24))
                    .foregroundStyle(.grey100)
                    .frame(height: 48)
                
                HStack {
                    Text("간격")
                        .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                        .foregroundStyle(.grey100)
                        .frame(height: 48)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                VStack(spacing: 0) {
                    ForEach(IntervalType.allCases, id: \.self) { type in
                        HStack {
                            Text(type.title)
                                .font(Fonts.Pretendard.regular.swiftUIFont(size: 16))
                                .foregroundStyle(.grey100)
                                .frame(height: 56)
                            
                            Spacer()
                            
                            if store.model.interval == type {
                                // 체크 버튼
                            }
                        }
                        .background(store.model.interval == type ? .grey20 : .clear)
                    }
                }
                
                HStack {
                    Text("반복")
                        .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                        .foregroundStyle(.grey100)
                        .frame(height: 48)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                VStack(spacing: 0) {
                    ForEach(RepeatType.allCases, id: \.self) { type in
                        HStack {
                            Text(type.title)
                                .font(Fonts.Pretendard.regular.swiftUIFont(size: 16))
                                .foregroundStyle(.grey100)
                                .frame(height: 56)
                            
                            Spacer()
                            
                            if store.model.repeat == type {
                                // 체크 버튼
                            }
                        }
                        .background(store.model.repeat == type ? .grey20 : .clear)
                    }
                }
            }
            .padding(30)
        }
    }
}

#Preview {
    SnoozeOptionView(store: Store(initialState: SnoozeOptionFeature.State(model: .init()), reducer: {
        SnoozeOptionFeature()
    }))
}

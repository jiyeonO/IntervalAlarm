//
//  SnoozeFeature.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/10/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SnoozeFeature {
    
    @ObservableState
    struct State: Equatable {
        var title: String = ""
        var isSnoozeOn: Bool = false
        var isSoundOn: Bool = false
        var sound: String = ""
    }
    
    enum Action {
        case onAppear
        case playSound
        case didTapStop
        case didTapSnooze
        case switchStore
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.soundClient) var soundClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let userInfo = userDefaultsClient.loadUserInfo()
                state.title = userInfo[NotificationUserInfoType.title.rawValue] as? String ?? "Alarm"
                state.isSnoozeOn = userInfo[NotificationUserInfoType.isSnooze.rawValue] as? Bool ?? false
                state.isSoundOn = userInfo[NotificationUserInfoType.isSound.rawValue] as? Bool ?? false
                state.sound = userInfo[NotificationUserInfoType.sound.rawValue] as? String ?? "bell"
                return .send(.playSound)
            case .playSound:
                if state.isSoundOn {
                    soundClient.playSound(state.sound)
                    soundClient.startVibration()
                } else {
                    soundClient.startVibration()
                }
                return .none
            case .didTapStop:
                return .send(.switchStore)
            case .didTapSnooze:
                let userInfo = userDefaultsClient.loadUserInfo()
                return .concatenate(.run { _ in try await NotificationRequestScheduler().snoozeNotification(with: userInfo) },
                                    .send(.switchStore))
            case .switchStore:
                if state.isSoundOn {
                    soundClient.stopSound()
                    soundClient.stopVibration()
                } else {
                    soundClient.stopVibration()
                }
                return .none
            }
        }
    }
    
}

struct SnoozeView: View {
    
    let store: StoreOf<SnoozeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                HStack {
                    Spacer()
                    Text(store.title)
                        .font(Fonts.Pretendard.medium.swiftUIFont(size: 72))
                        .foregroundStyle(.grey100)
                        .padding(.top, 150)
                    Spacer()
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        store.send(.didTapStop)
                    } label: {
                        Text("Stop")
                            .font(Fonts.Pretendard.medium.swiftUIFont(size: 35))
                            .foregroundStyle(.grey20)
                            .padding(15)
                            .frame(width: 140)
                            .background(.grey100)
                            .clipShape(.rect(cornerRadius: 25.0))
                    }
                    
                    if store.isSnoozeOn {
                        Button {
                            store.send(.didTapSnooze)
                        } label: {
                            Text("Snooze")
                                .font(Fonts.Pretendard.medium.swiftUIFont(size: 35))
                                .foregroundStyle(.grey20)
                                .padding(15)
                                .frame(width: 160)
                                .background(.grey100)
                                .clipShape(.rect(cornerRadius: 25.0))
                        }
                    }
                }
                .padding(.vertical, 70)
                .padding(.horizontal, 20)
            }
            .onAppear {
                store.send(.onAppear)
            }
            .background(.grey20)
        }
    }
}

#Preview {
    SnoozeView(store: Store(initialState: SnoozeFeature.State(), reducer: {
        SnoozeFeature()
    }))
}

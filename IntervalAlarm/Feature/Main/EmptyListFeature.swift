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
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case switchStore
        case didTapAddButton
        case toAddAlarm
        case didTapDenyPermission
        case sendNotification(AlarmModel)
        case addNotification(AlarmModel)
        
        case addAlarmAction(PresentationAction<AddAlarmFeature.Action>)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case toSetting
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapAddButton:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()

                return .run { send in
                    do {
                        let isAllowPush = try await PermissionHandler().onPermission(type: .push)
                        await isAllowPush ? send(.toAddAlarm) : send(.didTapDenyPermission)
                    } catch {
                        DLog.d(error.localizedDescription)
                        await send(.didTapDenyPermission)
                    }
                }
            case .addAlarmAction(.presented(.setAlarmOn(let alarm))):
                return .concatenate(
                    .send(.sendNotification(alarm))
                )
            case .addAlarmAction:
                return .none
            case .toAddAlarm:
                state.addAlarmState = AddAlarmFeature.State()
                return .none
            case .didTapDenyPermission:
                state.alert = AlertState {
                    TextState("push notifications are not allowed")
                } actions: {
                    ButtonState(role: .destructive) {
                        TextState("Cancel")
                    }
                    ButtonState(role: .cancel, action: .send(.toSetting)) {
                        TextState("Confirm")
                    }
                } message: {
                    TextState("please enable notifications in Settings to use the service")
                }
                
                return .none
            case .alert(.presented(.toSetting)):
                return .run { _ in
                    await ApplicationLoader.openSetting()
                }
            case .alert:
                return .none
                
            case .sendNotification(let alarm):
                return .run { send in
                    do {
                        let isAllowPush = try await PermissionHandler().onPermission(type: .push)
                        await isAllowPush ? send(.addNotification(alarm)) : send(.didTapDenyPermission)
                    } catch {
                        DLog.d(error.localizedDescription)
                        await send(.didTapDenyPermission)
                    }
                }
            case .addNotification(let alarm):
                return .concatenate(
                    .run { _ in
                        try await NotificationRequestScheduler().addNotification(requests: alarm.notificationRequests)
                    },
                    .send(.switchStore)
                )
            case .switchStore:
                return .none
            }
        }
        .ifLet(\.$addAlarmState, action: \.addAlarmAction) {
            AddAlarmFeature()
        }
        .ifLet(\.alert, action: \.alert)
    }
    
}

import SwiftUI
struct EmptyListView: View {
    
    @Perception.Bindable var store: StoreOf<EmptyListFeature>
    
    var body: some View {
        WithPerceptionTracking {
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
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
    
}

#Preview {
    EmptyListView(store: Store(initialState: EmptyListFeature.State()) {
        EmptyListFeature()
    })
}

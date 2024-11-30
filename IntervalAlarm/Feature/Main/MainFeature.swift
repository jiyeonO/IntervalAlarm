//
//  MainFeature.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case modified(AddAlarmFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var myAlarms: IdentifiedArrayOf<AlarmModel> = []
        
        var alarmStates: IdentifiedArrayOf<AlarmRowFeature.State> = []
        var path = StackState<Path.State>()

        var isPressed: Bool = false

        @Presents var addAlarmState: AddAlarmFeature.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case didTapAddButton
        case didSwipeDelete(IndexSet)
        case sendNotification(AlarmModel)
        case addNotification(AlarmModel)
        case removeNotification(AlarmModel)
        case didTapDenyPermission
        case toAddAlarm
        case setPressedState(Bool)

        case alarmActions(IdentifiedActionOf<AlarmRowFeature>)
        case path(StackActionOf<Path>)
        case addAlarmAction(PresentationAction<AddAlarmFeature.Action>)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case toSetting
        }
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.myAlarms = userDefaultsClient.loadAlarms()
                
                let states = state.myAlarms.map { AlarmRowFeature.State(model: $0) }
                state.alarmStates = IdentifiedArrayOf(uniqueElements: states)
                return .none
            case .didTapAddButton:
                return .run { send in
                    do {
                        let isAllowPush = try await PermissionHandler().onPermission(type: .push)
                        await isAllowPush ? send(.toAddAlarm) : send(.didTapDenyPermission)
                    } catch {
                        DLog.d(error.localizedDescription)
                        await send(.didTapDenyPermission)
                    }
                }
            case .didSwipeDelete(let indexSet):
                if let index = indexSet.first {
                    let targetID = state.myAlarms[index].uuidString
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: [targetID])
                }
                
                state.myAlarms.remove(atOffsets: indexSet)
                userDefaultsClient.saveAlarms(state.myAlarms)
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
                let request = alarm.notificationRequest
                return .run { _ in
                    try await UNUserNotificationCenter.current().add(request)
                }
            case .removeNotification(let alarm):
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.removePendingNotificationRequests(withIdentifiers: [alarm.uuidString])
                return .none
            case .didTapDenyPermission:
                state.alert = AlertState {
                    TextState("푸쉬 권한이 허용되지 않았어요")
                } actions: {
                    ButtonState(role: .destructive) {
                        TextState("취소")
                    }
                    ButtonState(role: .cancel, action: .send(.toSetting)) {
                        TextState("확인")
                    }
                } message: {
                    TextState("서비스 이용을 위해 설정에서 알림을 허용해주세요")
                }
                return .none
            case .toAddAlarm:
                state.addAlarmState = AddAlarmFeature.State()
                return .none
            case let .alarmActions(.element(id: id, action: .setAlarmOn)):
                guard let alarm = state.alarmStates[id: id]?.alarm else { return .none }
                return .send(.sendNotification(alarm))
            case let .alarmActions(.element(id: id, action: .setAlarmOff)):
                guard let alarm = state.alarmStates[id: id]?.alarm else { return .none }
                return .send(.removeNotification(alarm))
            case let .alarmActions(.element(id: id, action: .toModifyAlarm)):
                guard let alarm = state.alarmStates[id: id]?.alarm else { return .none }
                state.path.append(.modified(AddAlarmFeature.State(alarm: alarm)))
                return .none
            case .alert(.presented(.toSetting)):
                return .run { _ in
                    await ApplicationLoader.openSetting()
                }
            case let .path(action):
                switch action {
                case .element(id: _, action: .modified(.setAlarmOn(_))):
                    return .none
                default:
                    return .none
                }
            case .addAlarmAction(.presented(.setAlarmOn(let alarm))):
                return .merge(.send(.onAppear),
                              .send(.sendNotification(alarm)))
            case .alarmActions(_):
                return .none
            case .addAlarmAction:
                return .none
            case .alert:
                return .none
            case .setPressedState(let isPressed):
                state.isPressed = isPressed
                if !isPressed {
                    return .send(.didTapAddButton)
                }
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .forEach(\.alarmStates, action: \.alarmActions) {
            AlarmRowFeature()
        }
        .ifLet(\.$addAlarmState, action: \.addAlarmAction) {
            AddAlarmFeature()
        }
        .ifLet(\.alert, action: \.alert)
    }
    
}

import SwiftUI

struct MainView: View {
    
    @Perception.Bindable var store: StoreOf<MainFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                List {
                    AddAlarmButtonView()
                        .padding(.horizontal, 20.0)
                        .padding(.vertical, 10.0)
                        .noneSeperator()
                        .onTapGesture {
                            store.send(.setPressedState(true))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                store.send(.setPressedState(false))
                            }
                        }
                        .scaleEffect(store.isPressed ? 0.85 : 1)
                        .shadow(
                            color: .black.opacity(store.isPressed ? 0.8 : 0),
                            radius: store.isPressed ? 5 : 0
                        )
                        .animation(.easeIn, value: store.isPressed)

                    ForEach(store.scope(state: \.alarmStates, action: \.alarmActions)) { store in
                        VStack {
                            AlarmRowView(store: store)
                        }
                        .noneSeperator()
                    }
                    .onDelete {
                        store.send(.didSwipeDelete($0))
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
                .listStyle(.plain)
            } destination: { store in
                WithPerceptionTracking {
                    switch store.case {
                    case let .modified(store):
                        AddAlarmView(store: store)
                    }
                }
            }
            .sheet(item: $store.scope(state: \.addAlarmState, action: \.addAlarmAction)) { store in
                WithPerceptionTracking {
                    AddAlarmView(store: store)
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
}

#Preview {
    MainView(store: Store(initialState: MainFeature.State(myAlarms: AlarmModel.previewItems), reducer: {
        MainFeature()
    }))
}

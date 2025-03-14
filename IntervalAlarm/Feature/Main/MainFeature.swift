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
        case add(AddAlarmFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var alarmStates: IdentifiedArrayOf<AlarmRowFeature.State> = []
        var path = StackState<Path.State>()

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
        case didTapCheckButton
        case switchStore

        case alarmActions(IdentifiedActionOf<AlarmRowFeature>)
        case path(StackActionOf<Path>)
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
                let alarmModels = userDefaultsClient.loadAlarms()
                
                let states = alarmModels.map { AlarmRowFeature.State(model: $0) }
                state.alarmStates = IdentifiedArrayOf(uniqueElements: states)
                return .none
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
            case .didSwipeDelete(let indexSet):
                if let index = indexSet.first {
                    let alarm = state.alarmStates[index].alarm
                    state.alarmStates.remove(at: index)
                    
                    let alarmModels = state.alarmStates.map { $0.alarm }
                    userDefaultsClient.saveAlarms(alarmModels)
                    
                    if state.alarmStates.isEmpty {
                        return .concatenate(
                            .send(.removeNotification(alarm)),
                            .send(.switchStore)
                        )
                    } else {
                        return .send(.removeNotification(alarm))
                    }
                    
                }
                
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
                return .run { _ in
                    try await NotificationRequestScheduler().addNotification(requests: alarm.notificationRequests)
                }
            case .removeNotification(let alarm):
                NotificationRequestScheduler().removeNotifiaction(ids: alarm.weekdayIds)
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
            case .toAddAlarm:
                state.path.append(.add(AddAlarmFeature.State()))
                return .none
            case let .alarmActions(.element(id: id, action: .setAlarmOn)):
                guard let alarm = state.alarmStates[id: id]?.alarm else { return .none }
                
                let alarmModels = state.alarmStates.map { $0.alarm }
                userDefaultsClient.saveAlarms(alarmModels)
                
                return .send(.sendNotification(alarm))
            case let .alarmActions(.element(id: id, action: .setAlarmOff)):
                guard let alarm = state.alarmStates[id: id]?.alarm else { return .none }
                
                let alarmModels = state.alarmStates.map { $0.alarm }
                userDefaultsClient.saveAlarms(alarmModels)
                
                return .send(.removeNotification(alarm))
            case let .alarmActions(.element(id: id, action: .toModifyAlarm)):
                guard let alarm = state.alarmStates[id: id]?.alarm else { return .none }
                state.path.append(.add(AddAlarmFeature.State(entryType: .modify, alarm: alarm)))
                return .none
            case .alert(.presented(.toSetting)):
                return .run { _ in
                    await ApplicationLoader.openSetting()
                }
            case let .path(action):
                switch action {
                case .element(id: _, action: .add(.setAlarmOn(let alarm))):
                    return .merge(.send(.onAppear),
                                  .send(.sendNotification(alarm)))
                case .element(id: _, action: .add(.modifyAlarm(let alarm))):
                    return .concatenate(.send(.onAppear),
                                  .send(.removeNotification(alarm)),
                                  .send(.sendNotification(alarm)))
                default:
                    return .none
                }
            case .alarmActions(_):
                return .none
            case .alert:
                return .none
            case .didTapCheckButton:
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    for request in requests {
                        print("Pending Notification: \(request.identifier)")
                        print("Trigger: \(String(describing: request.trigger))")
                        print("Content: \(request.content.body)")
                    }
                }
                
                UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                    for notification in notifications {
                        print("Delivered Notification: \(notification.request.identifier)")
                        print("Content: \(notification.request.content.body)")
                    }
                }
                
                return .none
            case .switchStore:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .forEach(\.alarmStates, action: \.alarmActions) {
            AlarmRowFeature()
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
                    #if DEBUG
                    Button(action: {
                        store.send(.didTapCheckButton)
                    }, label: {
                        Text("Check Alarms")
                    })
                    #endif
                    
                    Button {
                        store.send(.didTapAddButton)
                    } label: {
                        AddAlarmButtonView()
                    }
                    .padding(.horizontal, 20.0)
                    .padding(.vertical, 10.0)
                    .listRowBackground(Colors.grey20.swiftUIColor)
                    .noneSeperator()

                    ForEach(store.scope(state: \.alarmStates, action: \.alarmActions)) { store in
                        AlarmRowView(store: store)
                            .listRowBackground(Colors.grey20.swiftUIColor)
                            .noneSeperator()
                    }
                    .onDelete {
                        store.send(.didSwipeDelete($0))
                    }
                    
                    HStack {
                        Spacer()
                        Images.logo.swiftUIImage
                        Spacer()
                    }
                    .listRowBackground(Colors.grey20.swiftUIColor)
                    .noneSeperator()
                }
                .listBackground(.grey20)
                .toolbar(.hidden, for: .navigationBar)
                .listStyle(.plain)
            } destination: { store in
                WithPerceptionTracking {
                    switch store.case {
                    case let .add(store):
                        AddAlarmView(store: store)
                    }
                }
            }
            .background(.grey20)
            .alert($store.scope(state: \.alert, action: \.alert))
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
}

#Preview {
    MainView(store: Store(initialState: MainFeature.State(), reducer: {
        MainFeature()
    }))
}

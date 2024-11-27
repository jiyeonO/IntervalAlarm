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
        case detail(DetailFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var myAlarms: IdentifiedArrayOf<AlarmModel> = []
        
        var path = StackState<Path.State>()
        @Presents var addAlarmState: AddAlarmFeature.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case didTapAddButton
        case didTapAlarm(AlarmModel)
        case didSwipeDelete(IndexSet)
        case didTapNotification
        case didTapDenyPermission
        case setNotification
        
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
                return .none
            case .didTapAddButton:
                state.addAlarmState = AddAlarmFeature.State()
                return .none
            case .didTapAlarm(let alarm):
                state.path.append(.detail(DetailFeature.State(alarm: alarm)))
                return .none
            case .didSwipeDelete(let indexSet):
                state.myAlarms.remove(atOffsets: indexSet)
                userDefaultsClient.saveAlarms(state.myAlarms)
                return .none
            case .didTapNotification:
                return .run { send in
                    do {
                        let isAllowPush = try await PermissionHandler().onPermission(type: .push)
                        await isAllowPush ? send(.setNotification) : send(.didTapDenyPermission)
                    } catch {
                        DLog.d(error.localizedDescription)
                        await send(.didTapDenyPermission)
                    }
                }
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
            case .alert(.presented(.toSetting)):
                return .run { _ in
                    await ApplicationLoader.openSetting()
                }
            case .setNotification:
                let request = self.notificationRequestModel()
                return .run { _ in
                    return try await UNUserNotificationCenter.current().add(request)
                }
            case let .path(action):
                switch action {
                case .element(id: _, action: .detail(.onDisappear)):
                    return .none
                default:
                    return .none
                }
            case .addAlarmAction(.presented(.saveAlarm)):
                return .send(.onAppear)
            case .addAlarmAction:
                return .none
            case .alert:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$addAlarmState, action: \.addAlarmAction) {
            AddAlarmFeature()
        }
        .ifLet(\.alert, action: \.alert)
    }
    
    func notificationRequestModel() -> UNNotificationRequest {
        let content = UNMutableNotificationContent() // TODO: UNCalendarNotificationTrigger
        content.title = "Push Alarm Notification"
        content.body = "Wake Up!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5.0,
            repeats: false
        )
        
        return UNNotificationRequest(identifier: UUID().uuidString, // TODO: AlarmModel ID
                                     content: content, trigger: trigger)
    }
    
}

import SwiftUI

struct MainView: View {
    
    @Perception.Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                List {
                    ForEach(store.myAlarms) { alarm in
                        VStack {
                            AlarmRowView(store: Store(initialState: AlarmRowFeature.State(model: alarm)) {
                                AlarmRowFeature()
                            })
                            CustomDivider()
                        }
                        .noneSeperator()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.didTapAlarm(alarm))
                        }
                    }
                    .onDelete {
                        store.send(.didSwipeDelete($0))
                    }
                    
                    Button {
                        store.send(.didTapNotification)
                    } label: {
                        Text("Push 테스트 버튼")
                            .font(Fonts.Pretendard.bold.swiftUIFont(size: 25))
                            .foregroundStyle(.yellow)
                    }
                    .frame(height: 40)
                }
                .listStyle(.plain)
                .navigationTitle("알람")
                .toolbar {
                    ToolbarItem {
                        CustomNavigationView(type: .add) {
                            store.send(.didTapAddButton)
                        }
                    }
                }
            } destination: { store in
                WithPerceptionTracking {
                    switch store.case {
                    case let .detail(store):
                        DetailView(store: store)
                    }
                }
            }
            .sheet(item: $store.scope(state: \.addAlarmState, action: \.addAlarmAction)) { store in
                AddAlarmView(store: store)
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


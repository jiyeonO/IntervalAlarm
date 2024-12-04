//
//  IntervalAlarmApp.swift
//  IntervalAlarm
//
//  Created by 오지연 on 7/3/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct IntervalAlarmApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    static let store = Store(initialState: MainRouteFeature.State.empty(EmptyListFeature.State())) {
        MainRouteFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            WithPerceptionTracking {
                MainRouteView(store: IntervalAlarmApp.store)                
            }
        }
    }
    
}

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
    
    static let store = Store(initialState: MainFeature.State()) {
        MainFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(store: IntervalAlarmApp.store)
        }
    }
    
}

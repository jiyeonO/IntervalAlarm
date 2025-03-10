//
//  UserDefaultsClient.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/22/24.
//

import Foundation
import ComposableArchitecture

struct UserDefaultsClient {
    
    var loadUserInfo: @Sendable () -> [String: Any]
    var saveUserInfo: @Sendable (_ dict: [String: Any]) -> Void
    var loadIsLaunchFirst: @Sendable () -> Bool
    var saveIsLaunchFirst: @Sendable (_ isLaunchFirst: Bool) -> Void
    var loadAlarms: @Sendable () -> [AlarmModel]
    var modifyAlarm: @Sendable (_ alarm: AlarmModel) -> Void
    var saveAlarm: @Sendable (_ alarm: AlarmModel) -> Void
    var saveAlarms: @Sendable (_ alarms: [AlarmModel]) -> Void
    
}

extension UserDefaultsClient: DependencyKey {
    
    static var liveValue: UserDefaultsClient = .init {
        let userDefault = UserDefaultsStorage()
        return userDefault.loadUserInfo()
    } saveUserInfo: { dict in
        let userDefault = UserDefaultsStorage()
        userDefault.saveUserInfo(dict)
    } loadIsLaunchFirst: {
        let userDefault = UserDefaultsStorage()
        return userDefault.loadIsFirstLaunch()
    } saveIsLaunchFirst: { isLaunchFirst in
        let userDefault = UserDefaultsStorage()
        userDefault.saveIsFirstLaunch(isLaunchFirst)
    } loadAlarms: {
        let userDefault = UserDefaultsStorage()
        return userDefault.loadAlarms()
    } modifyAlarm: { alarm in
        let userDefault = UserDefaultsStorage()
        userDefault.modifyAlarm(model: alarm)
    } saveAlarm: { alarm in
        let userDefault = UserDefaultsStorage()
        userDefault.saveAlarm(model: alarm)
    } saveAlarms: { alarms in
        let userDefault = UserDefaultsStorage()
        userDefault.saveAlarms(models: alarms)
    }
    
}

extension DependencyValues {
    
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
    
}

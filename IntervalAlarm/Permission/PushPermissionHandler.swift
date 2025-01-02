//
//  PushPermissionHandler.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/16/24.
//

import UserNotifications

enum NotificationCategories: String {
    
    case alarm = "alarm_notification"
    
}

struct PushPermissionHandler {

    func hasPushPermission() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized:
            return true
        case .notDetermined:
            return try await askNotificationPermission()
        default:
            return false
        }
    }
    
}

private extension PushPermissionHandler {
    
    func askNotificationPermission() async throws -> Bool {
        let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        
        // TODO: - 여기서 호출 시 유저가 설정 -> 앱 -> 알림 켰을 때 카테고리 세팅이 안되는 케이스 생김(AppDelegate에서 알림 설정 상관 없이 카테고리 설장 하도록 해놓음)
//        if granted {
//            try await setCategories()
//        }
        
        return granted
    }
 
    func setCategories() async throws {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        if settings.authorizationStatus == .authorized {
            
            let doneAction = UNNotificationAction(identifier: "action.done", title: "Done")
            let cancelAction = UNNotificationAction(identifier: "action.cancle", title: "Cancel")
            
            let alarmCategory = UNNotificationCategory(
                identifier: NotificationCategories.alarm.rawValue,
                actions: [doneAction, cancelAction],
                intentIdentifiers: [],
                options: [])
            
            let categories: Set<UNNotificationCategory> = [alarmCategory]
            UNUserNotificationCenter.current().setNotificationCategories(categories)
        }
    }
    
}

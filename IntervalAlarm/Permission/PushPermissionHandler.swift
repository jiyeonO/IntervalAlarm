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
        
        if granted {
            try await setCategories()
        }
        
        return granted
    }
 
    func setCategories() async throws {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        if settings.authorizationStatus == .authorized {
            let alarmCategory = UNNotificationCategory(
                identifier: NotificationCategories.alarm.rawValue,
                actions: [],
                intentIdentifiers: [],
                options: [])
            
            let categories: Set<UNNotificationCategory> = [alarmCategory]
            UNUserNotificationCenter.current().setNotificationCategories(categories)
        }
    }
    
}

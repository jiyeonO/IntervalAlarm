//
//  PermissionHandler.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/27/24.
//
import UserNotifications

enum PermissionType {
    
    case push
    
}

struct PermissionHandler {
    
    func onPermission(type: PermissionType) async throws -> Bool {
        switch type {
        case .push:
            return try await self.checkPushPermission()
        }
    }
    
}

private extension PermissionHandler {
    
    func checkPushPermission() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized:
            return true
        case .notDetermined:
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        default:
            return false
        }
    }
    
}

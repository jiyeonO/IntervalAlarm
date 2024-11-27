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
        
        guard settings.authorizationStatus == .notDetermined else { return true }
        
        return try await center.requestAuthorization(options: [.alert, .badge, .sound])
    }
    
}

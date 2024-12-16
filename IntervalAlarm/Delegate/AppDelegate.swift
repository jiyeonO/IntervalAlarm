//
//  AppDelegate.swift
//  IntervalAlarm
//
//  Created by Jiwon Yoon on 11/27/24.
//

import SwiftUI
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if !DEBUG
        FirebaseApp.configure()
        #endif

        UNUserNotificationCenter.current().delegate = self
        
        Task {
            try await PermissionHandler().onPermission(type: .push)
        }
        
        return true
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        DLog.d("willPresent notification: \(notification.request.content.title)")
        
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            let userDefault = UserDefaultsStorage()
            userDefault.saveUserInfo(userInfo)
        }
        
        return [.sound, .banner, .list, .badge]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        DLog.d("didReceive response: \(response.notification.request.content.title)")
        
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            let userDefault = UserDefaultsStorage()
            userDefault.saveUserInfo(userInfo)
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterIdentifier.onSnoozeAlarm), object: nil)
        }
    }
    
}

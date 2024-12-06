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
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
//        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [], intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([category])
        return true
    }

}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner, .list, .badge]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        DLog.d("didReceive response: \(response.notification.request.content.title)")
    }
    
}

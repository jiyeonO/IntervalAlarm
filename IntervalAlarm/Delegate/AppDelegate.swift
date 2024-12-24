//
//  AppDelegate.swift
//  IntervalAlarm
//
//  Created by Jiwon Yoon on 11/27/24.
//

import SwiftUI
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {

    private let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if !DEBUG
        FirebaseApp.configure()
        #endif
        center.delegate = self
        self.setNotificationCatogory()

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


        // TODO: - 버튼 identifier에 따라 액션처리 추가
        // Custom Notification에 들어간 버튼 중 어떤 버튼이 눌렸는지 확인 후 액션 처리 action.done or action.cancle
        // userNotificationCenter(_:didReceive:) > Button actionIdentifier: action.done
        DLog.d("Button actionIdentifier: \(response.actionIdentifier)")
    }

}

private extension AppDelegate {

    func setNotificationCatogory() {
        let doneAction = UNNotificationAction(identifier: "action.done", title: "Done")
        let cancelAction = UNNotificationAction(identifier: "action.cancle", title: "Cancel")

        let categories = UNNotificationCategory(
            identifier: "myNotificationCategory",
            actions: [doneAction, cancelAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )

        center.setNotificationCategories([categories])

    }

}

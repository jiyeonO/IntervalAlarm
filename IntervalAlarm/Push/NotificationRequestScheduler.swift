//
//  NotificationRequestScheduler.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/10/24.
//

import UserNotifications

struct NotificationRequestScheduler {
    
    func addNotification(with alarm: AlarmModel) async throws {
        let requests = alarm.notificationRequests
        for request in requests {
            try await UNUserNotificationCenter.current().add(request)
        }
    }
    
    func removeNotifiaction(with alarm: AlarmModel) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: alarm.weekdayIds)
    }
    
    func snoozeNotification(with userInfo: [String: Any]) async throws {
        let content = getNotificationContent(with: userInfo)
        guard let uuidString = content.userInfo[NotificationUserInfoType.uuid.rawValue] as? String else {
            return
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // TODO: NotificationUserInfoType.interval.rawValue 시간 적용 필요!
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        try await UNUserNotificationCenter.current().add(request)
    }
    
}

private extension NotificationRequestScheduler {

    func getNotificationContent(with userInfo: [String: Any]) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = NotificationCategories.alarm.rawValue
        if let title = userInfo[NotificationUserInfoType.title.rawValue] as? String {
            content.title = title
        }
        if let sound = userInfo[NotificationUserInfoType.sound.rawValue] as? String {
            content.sound = .ringtoneSoundNamed(.init(sound + ".mp3"))
        }
        content.userInfo = userInfo
        return content
    }
    
}

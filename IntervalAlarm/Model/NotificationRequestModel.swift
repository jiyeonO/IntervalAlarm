//
//  NotificationRequestModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/28/24.
//
import Foundation
import UserNotifications

extension AlarmModel {
    
    var notificationRequest: UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "⏰ \(self.notificationTitle)"
        content.body = "User 알람 메모 노출"
        content.sound = .default
        content.categoryIdentifier = "myNotificationCategory" // extension Info(UNNotificationExtensionCategory) 와 동일한 값 필요하면 수정

        var dateComponents = DateComponents()
        dateComponents.hour = self.hourValueIn24
        dateComponents.minute = self.minuteValue
//        dateComponents.weekday = 2 // 월요일 반복
//        dateComponents.day = 5 // 매월 5일
//        dateComponents.month = 1 // 매 1월
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        return UNNotificationRequest(identifier: self.uuidString,
                                     content: content, trigger: trigger)
    }
    
    var notificationRequests: [UNNotificationRequest] {
        let content = UNMutableNotificationContent()
        content.title = "⏰ \(self.notificationTitle)"
        content.body = "User 알람 메모 노출"
        content.sound = .default
        content.categoryIdentifier = "myNotificationCategory" // extension Info(UNNotificationExtensionCategory) 와 동일한 값 필요하면 수정

        if self.repeatWeekdaysValue.isEmpty {
            return [self.notificationRequest]
        } else {
            return self.repeatWeekdaysValue.map {
                var dateComponents = DateComponents()
                
                dateComponents.hour = self.hourValueIn24
                dateComponents.minute = self.minuteValue
                dateComponents.weekday = $0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                return UNNotificationRequest(identifier: self.getNotificationIdentifier(for: $0), content: content, trigger: trigger)
            }
        }
    }
    
}

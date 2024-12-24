//
//  NotificationRequestModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/28/24.
//
import Foundation
import UserNotifications

extension AlarmModel {
    
    var notificationContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "⏰ \(self.notificationTitle)"
        content.categoryIdentifier = NotificationCategories.alarm.rawValue
        content.sound = .ringtoneSoundNamed(.init(self.sound.melody.rawValue + SoundFormat.mp3)) // TODO: 진동
        content.userInfo = [NotificationUserInfoType.title.rawValue: content.title,
                            NotificationUserInfoType.uuid.rawValue: self.uuidString,
                            NotificationUserInfoType.isSnooze.rawValue: self.snooze.isOn,
                            NotificationUserInfoType.interval.rawValue: self.snooze.interval.value,
                            NotificationUserInfoType.repeatTime.rawValue: self.snooze.repeat.rawValue,
                            NotificationUserInfoType.isSound.rawValue: self.sound.isOn,
                            NotificationUserInfoType.sound.rawValue: self.sound.melody.rawValue]
        return content
    }

    var notificationRequest: UNNotificationRequest {
        var dateComponents = DateComponents()
        dateComponents.hour = self.hourValueIn24
        dateComponents.minute = self.minuteValue
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        return UNNotificationRequest(identifier: self.uuidString,
                                     content: self.notificationContent, trigger: trigger)
    }
    
    var notificationRequests: [UNNotificationRequest] {
        if self.repeatWeekdaysValue.isEmpty {
            return [self.notificationRequest]
        } else {
            return self.repeatWeekdaysValue.map {
                var dateComponents = DateComponents()
                
                dateComponents.hour = self.hourValueIn24
                dateComponents.minute = self.minuteValue
                dateComponents.weekday = $0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                return UNNotificationRequest(identifier: self.getNotificationIdentifier(for: $0), content: self.notificationContent, trigger: trigger)
            }
        }
    }
    
}

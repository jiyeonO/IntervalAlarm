//
//  NotificationViewController.swift
//  IntervalAlarmNoti
//
//  Created by Jiwon Yoon on 12/24/24.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.titleLabel?.text = notification.request.content.title
        self.contentLabel?.text = notification.request.content.body
    }

}

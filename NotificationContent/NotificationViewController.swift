//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by 오지연 on 12/6/24.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.title
        self.descriptionLabel?.text = notification.request.content.body
    }
    
}

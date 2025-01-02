//
//  NotificationViewController.swift
//  IntervalAlarmNoti
//
//  Created by Jiwon Yoon on 12/24/24.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SnapKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(self.titleLabel)
            $0.bottom.equalToSuperview().offset(-20.0)
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        self.setupViews()
    }
    
    func didReceive(_ notification: UNNotification) {
        print("extension title: \(notification.request.content.title)")
        self.titleLabel.text = notification.request.content.title
        self.contentLabel.text = notification.request.content.body
    }

}

private extension NotificationViewController {
    
    func setupViews() {
        self.view.addSubview(self.containerView)
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

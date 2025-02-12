//
//  UINavigation+Extension.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2/6/25.
//

import UIKit

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = nil
    }
    
}

//
//  ApplicationLoader.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/27/24.
//

import UIKit

enum ApplicationURL {
    
    case setting
    
}

extension ApplicationURL {
    
    var link: String {
        switch self {
        case .setting:
            return UIApplication.openSettingsURLString
        }
    }
    
    var url: URL? {
        URL(string: link)
    }
    
}

class ApplicationLoader {
    
    static func openSetting() async {
        await open(type: .setting)
    }
    
    static func open(type: ApplicationURL) async {
        guard let url = type.url, await UIApplication.shared.canOpenURL(url) else { return }
        
        await UIApplication.shared.open(url)
    }

}

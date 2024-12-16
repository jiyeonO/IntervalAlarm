//
//  PermissionHandler.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/27/24.
//

enum PermissionType {
    
    case push
    
}

struct PermissionHandler {
    
    func onPermission(type: PermissionType) async throws -> Bool {
        switch type {
        case .push:
            return try await PushPermissionHandler().checkPushPermission()
        }
    }

}

//
//  UserDefaultManager.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/22/24.
//
import Foundation
import InternalStorage
import ComposableArchitecture

final class UserDefaultsStorage: UserDefaultsStorageProtocol {
    
    enum KeyConstant: String, UserDefaultsStorageKey {
        
        case isFirstLaunch
        case userInfo
        case alarms
        
    }
    
    typealias K = KeyConstant
    
    let standard: UserDefaults
    
    init(standard: UserDefaults = .standard) {
        self.standard = standard
    }
    
}

extension UserDefaultsStorage {
    
    func loadUserInfo() -> [String: Any] {
        guard let jsonData = UserDefaults.standard.data(forKey: KeyConstant.userInfo.rawValue),
              let dict = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else { return [:] }
        return dict
    }
    
    func saveUserInfo(_ dict: [String: Any]) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict) {
            UserDefaults.standard.set(jsonData, forKey: KeyConstant.userInfo.rawValue)
        }
    }
    
    func loadIsFirstLaunch() -> Bool {
        self[.isFirstLaunch] ?? false
    }
    
    func saveIsFirstLaunch(_ data: Bool) {
        self[.isFirstLaunch] = data
    }

    func saveAlarm(model: AlarmModel) {
        var alarms = loadAlarms()
        alarms.append(model)
        saveObjects(alarms, key: .alarms)
    }
    
    func modifyAlarm(model: AlarmModel) {
        var alarms = loadAlarms()
        alarms = alarms.map { $0.id == model.id ? model : $0 }
        saveObjects(alarms, key: .alarms)
    }
    
    func saveAlarms(models: [AlarmModel]) {
        saveObjects(models, key: .alarms)
    }
    
    func loadAlarms() -> [AlarmModel] {
        return loadObjects(.alarms) ?? []
    }
    
}

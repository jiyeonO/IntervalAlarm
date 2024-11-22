//
//  UserDefaultManager.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/22/24.
//
import Foundation
import InternalStorage

final class UserDefaultsStorage: UserDefaultsStorageProtocol {
    
    enum KeyConstant: String, UserDefaultsStorageKey {
        
        case isFirstLaunch
        case alarms
        
    }
    
    typealias K = KeyConstant
    
    let standard: UserDefaults
    
    init(standard: UserDefaults = .standard) {
        self.standard = standard
    }
    
}

extension UserDefaultsStorage {
    
    func loadIsFirstLaunch() -> Bool {
        self[.isFirstLaunch] ?? false
    }
    
    func saveIsFirstLaunch(_ data: Bool) {
        self[.isFirstLaunch] = data
    }
    
    func saveAlarms(models: [AlarmModel]) {
        saveObjects(models, key: .alarms)
    }
    
    func loadAlarms() -> [AlarmModel] {
        loadObjects(.alarms) ?? AlarmModel.previewItems
    }
    
}

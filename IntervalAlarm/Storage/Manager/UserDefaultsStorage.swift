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

    func saveAlarm(model: AlarmModel) {
        var alarms = loadAlarms()
        alarms.append(model)
        saveObjects(Array(alarms), key: .alarms)
    }
    
    func saveAlarms(models: IdentifiedArrayOf<AlarmModel>) {
        saveObjects(Array(models), key: .alarms)
    }
    
    func loadAlarms() -> IdentifiedArrayOf<AlarmModel> {
        let alarms = loadObjects(.alarms) ?? Array(AlarmModel.previewItems)
        return IdentifiedArrayOf(uniqueElements: alarms)
    }
    
}

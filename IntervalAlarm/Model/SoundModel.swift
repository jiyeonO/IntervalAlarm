//
//  SoundModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/30/24.
//

enum SoundType: String, Codable, CaseIterable {
    
    case radial
    case classic
    
}

struct SoundModel: Codable, Equatable {
    
    var isOn: Bool = true
    var value: SoundType = .radial
    
}

extension SoundModel {
    
    var title: String {
        self.value.rawValue
    }
    
}

//
//  SoundModel.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/30/24.
//
import SwiftUI

enum VibrateType: String, Codable, CaseIterable {
    
    case none
    case light
    case medium
    case heavy
    
}

enum MelodyType: String, Codable, CaseIterable {
    
    case none
    case radial
    case classic
    
}

struct SoundModel: Codable, Equatable {
    
    var isOn: Bool = true
    var vibrate: VibrateType = .none
    var melody: MelodyType = .radial
    
}

extension SoundModel {
    
    var isMelodyOn: Bool {
        self.melody != .none
    }
    
    var title: LocalizedStringKey {
        isMelodyOn ? LocalizedStringKey(self.melody.rawValue) : LocalizedStringKey(self.vibrate.rawValue)
    }
    
}

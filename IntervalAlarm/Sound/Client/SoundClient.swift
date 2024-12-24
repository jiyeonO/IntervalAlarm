//
//  SoundClient.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/16/24.
//

import Foundation
import ComposableArchitecture

struct SoundClient {
    
    var playSound: @Sendable (String) -> Void
    var stopSound: @Sendable () -> Void
    var startVibration: @Sendable () -> Void
    var stopVibration: @Sendable () -> Void
    
}

extension SoundClient: DependencyKey {
    
    static var liveValue: SoundClient = .init { soundName in
        SoundManager.shared.playSound(soundName)
    } stopSound : {
        SoundManager.shared.stopSound()
    } startVibration: {
        SoundManager.shared.startVibration()
    } stopVibration: {
        SoundManager.shared.stopVibration()
    }
    
}

extension DependencyValues {
    
    var soundClient: SoundClient {
        get { self[SoundClient.self] }
        set { self[SoundClient.self] = newValue }
    }
    
}

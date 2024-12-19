//
//  HeightPreferenceKey.swift
//  IntervalAlarm
//
//  Created by Davidyoon on 12/10/24.
//

import SwiftUI

struct HeightPreferenceKey: PreferenceKey {

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

}

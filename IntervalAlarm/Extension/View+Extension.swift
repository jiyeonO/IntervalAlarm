//
//  View+Extension.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/3/24.
//
import SwiftUI

extension View {

    func measureHeight() -> some View {
//    func measureHeight(_ height: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .presentationDetents([.height(geometry.size.height)])
//                    .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
//                    .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
//                        height(newHeight)
//                    }
            }
        )
    }

}

//
//  View+Extension.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/3/24.
//
import SwiftUI
import ComposableArchitecture

extension View {
    
    func measureHeight() -> some View {  // TODO: - 이름 변경할 필요가 있어 보임(presentationDetents 까지 포함되어 있기 때문)
        background(
            GeometryReader { geometry in
                WithPerceptionTracking {
                    Color.clear
                        .presentationDetents([.height(geometry.size.height)])
                }
            }
        )
    }
    
    func measureHeight(_ height: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                WithPerceptionTracking {
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                        .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                            height(newHeight)
                        }
                }
            }
        )
    }
    
}

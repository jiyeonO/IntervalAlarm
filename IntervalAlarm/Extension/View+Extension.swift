//
//  View+Extension.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/3/24.
//
import SwiftUI

extension View {
    
    func measureHeight() -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .presentationDetents([.height(geometry.size.height)])
            }
        )
    }
    
}

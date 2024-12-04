//
//  ListBackgroundModifier.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/4/24.
//
import SwiftUI

struct ListBackgroundModifier: ViewModifier {
    
    let background: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .background(background)
        } else {
            content
                .scrollContentBackground(.hidden)
                .background(background)
        }
    }
    
}

extension View {
    
    func listBackground(_ background: Color) -> some View {
        self.modifier(ListBackgroundModifier(background: background))
    }
    
}

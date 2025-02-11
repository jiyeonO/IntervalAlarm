//
//  SwipeModifier.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2/5/25.
//
import SwiftUI

struct SwipeModifier: ViewModifier {
    
    let action: (() -> Void)
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > UIScreen.main.bounds.width * 0.3 {
                            action()
                        }
                    }
            )
    }
    
}

extension View {
    
    func swipeToDismiss(_ action: @escaping () -> Void) -> some View {
        self.modifier(SwipeModifier(action: action))
    }
    
}

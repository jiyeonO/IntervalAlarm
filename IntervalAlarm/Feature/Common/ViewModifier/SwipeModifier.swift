//
//  SwipeModifier.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2/5/25.
//
import SwiftUI

struct SwipeModifier: ViewModifier {
    
    let action: (() -> Void)
    
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .animation(.interactiveSpring(), value: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width > 0 {
                            offset = gesture.translation.width
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.width > UIScreen.main.bounds.width * 0.3 {
                            action()
                        } else {
                            withAnimation(.interactiveSpring()) {
                                offset = 0
                            }
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

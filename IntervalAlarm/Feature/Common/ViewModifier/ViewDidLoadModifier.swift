//
//  ViewDidLoadModifier.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/6/23.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    
    @State private var onLoad = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !onLoad {
                    onLoad.toggle()
                    action?()
                }
            }
    }
    
}

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
    
}

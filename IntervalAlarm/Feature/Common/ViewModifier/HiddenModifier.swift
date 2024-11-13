//
//  HiddenModifiter.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2023/11/01.
//

import SwiftUI

struct HiddenModifier: ViewModifier {
    
    var isHide: Binding<Bool>
    
    func body(content: Content) -> some View {
        if isHide.wrappedValue {
            content.hidden()
        } else {
            content
        }
    }
}

extension View {
    
    func hiddenModifier(isHide: Binding<Bool>) -> some View {
        return self.modifier(HiddenModifier(isHide: isHide))
    }
    
}

//
//  BottomToastModifier.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/29/23.
//

import SwiftUI

struct BottomToastModifier: ViewModifier {
    
    var title: String
    @Binding var isHidden: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if !isHidden {
                bottomToast
            }
        }
    }
    
    @ViewBuilder
    var bottomToast: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(title)
                .font(Fonts.Pretendard.bold.swiftUIFont(size: 13))
                .foregroundStyle(.white100)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(height: 40)
            .background(Capsule().fill(Colors.grey70.swiftUIColor))
            .padding(.bottom, 100)
        }
    }
    
}

extension View {
    
    func bottomToast(title: String, isHidden: Binding<Bool>) -> some View {
        self.modifier(BottomToastModifier(title: title, isHidden: isHidden))
    }
    
}

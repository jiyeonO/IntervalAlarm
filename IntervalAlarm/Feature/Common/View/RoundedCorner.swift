//
//  RoundedCorner.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/11/23.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func roundedBorder(radius: CGFloat,
                       color: ColorAsset,
                       inset: CGFloat = 0,
                       width: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .inset(by: inset)
                .stroke(color.swiftUIColor, lineWidth: width)
        )
    }
    
}

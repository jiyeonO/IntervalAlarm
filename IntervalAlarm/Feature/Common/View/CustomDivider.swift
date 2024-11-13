//
//  CustomDivider.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2023/12/11.
//

import SwiftUI

enum DividerDirectionType {
    
    case horizontal
    case vertical
    
}

struct CustomDivider: View {
    
    let color: Color
    let size: CGFloat
    let direction: DividerDirectionType
    
    init(
        color: ColorAsset = Colors.grey100,
        size: CGFloat = 1.0,
        direction: DividerDirectionType = .horizontal
    ) {
        self.color = color.swiftUIColor
        self.size = size
        self.direction = direction
    }
    
    var body: some View {
        switch direction {
        case .horizontal:
            color
                .frame(height: size)
        case .vertical:
            color
                .frame(width: size)
        }
    }
    
}

struct CustomDivider_Preview: PreviewProvider {
    
    static var previews: some View {
        VStack {
            CustomDivider(color: Colors.grey900, direction: .horizontal)
            
            CustomDivider(color: Colors.grey900, direction: .vertical)
        }
    }
    
}

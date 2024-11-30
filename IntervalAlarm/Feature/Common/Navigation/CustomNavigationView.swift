//
//  CustomNavigationView.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/13/24.
//

import SwiftUI

enum NavigationBarType {
    case add
    case save
}

extension NavigationBarType {
    
    var buttonTitle: String {
        switch self {
        case .add:
            "추가"
        case .save:
            "저장"
        }
    }
}

struct CustomNavigationView: View {
    
    let type: NavigationBarType
    let action: (() -> Void)
    
    var body: some View {
        HStack {
            Spacer()
            Text(type.buttonTitle)
                .font(Fonts.Pretendard.semiBold.swiftUIFont(size: 16))
                .foregroundStyle(.blue10)
                .onTapGesture {
                    action()
                }
        }
        .padding(15)
    }
}

#Preview {
    CustomNavigationView(type: .add) {
        print("did tap add button")
    }
    .border(.grey100)
}

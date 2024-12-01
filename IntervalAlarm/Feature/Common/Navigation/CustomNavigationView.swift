//
//  CustomNavigationView.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/13/24.
//

import SwiftUI

enum NavigationBarType {
    
    case `default`
    case save
    
}

extension NavigationBarType {
    
    var buttonTitle: String {
        switch self {
        case .save:
            "저장"
        default:
            ""
        }
    }
    
}

struct CustomNavigationView: View {
    
    let type: NavigationBarType
    
    let backAction: (() -> Void)
    let doneAction: (() -> Void)?
    
    init(type: NavigationBarType, backAction: @escaping () -> Void, doneAction: (() -> Void)? = nil) {
        self.type = type
        self.backAction = backAction
        self.doneAction = doneAction
    }
    
    var body: some View {
        HStack {
            Button {
                backAction()
            } label: {
                Images.icBack.swiftUIImage
                    .resizable()
                    .frame(width: 56, height: 56)
            }
            
            Spacer()
            
            if type != .default {
                Button {
                    doneAction?()
                } label: {
                    Text(type.buttonTitle)
                        .font(Fonts.Pretendard.semiBold.swiftUIFont(size: 16))
                        .foregroundStyle(.grey90)
                }
            }
        }
    }
}

#Preview {
    Group {
        CustomNavigationView(type: .save) {
            DLog.d("did tap back button")
        } doneAction: {
            DLog.d("did tap done button")
        }
        .background(.grey20)
        .border(.grey100)
        
        CustomNavigationView(type: .default) {
            DLog.d("did tap back button")
        }
        .background(.grey20)
        .border(.grey100)
    }
}

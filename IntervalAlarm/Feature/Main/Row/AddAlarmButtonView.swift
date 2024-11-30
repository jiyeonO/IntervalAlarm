//
//  AddAlarmButtonView.swift
//  IntervalAlarm
//
//  Created by Jiwon Yoon on 11/30/24.
//

import SwiftUI

struct AddAlarmButtonView: View {

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "plus")
                Text("알람 추가할래요")
                    .font(Fonts.Pretendard.semiBold.swiftUIFont(size: 16.0))
                Spacer()
            }
            .padding(.vertical, 16.0)
            .padding(.horizontal, 8.0)
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 12.0))
        }
    }

}

#Preview {
    AddAlarmButtonView()
}

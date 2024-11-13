//
//  TimePickerView.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2023/07/30.
//

import SwiftUI

struct TimePickerView: View {

    @Binding var isOpen: Bool
    @Binding var hour: Int
    @Binding var minute: Int

    let info: TimeRangeInfo

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(asset: Colors.grey900)
                .opacity(0.3)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isOpen.toggle()
                    }
                }
            
            VStack {
                HStack {
                    Picker("Hour", selection: $hour) {
                        ForEach(info.hourRange, id: \.self) { hour in
                            Text(hour.toString)
                                .tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Text(":")
                    
                    Picker("Minute", selection: $minute) {
                        ForEach(info.minuteRange, id: \.self) { minute in
                            Text(minute.toString)
                                .tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .frame(height: info.height)
            }
            .transition(.move(edge: .bottom))
            .background(Colors.grey100.swiftUIColor)
            .shadow(color: Colors.grey900.swiftUIColor.opacity(0.25), radius: 6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

}

#Preview {
    TimePickerView(isOpen: .constant(true),
                   hour: .constant(0),
                   minute: .constant(0),
                   info: .previewItem)
}

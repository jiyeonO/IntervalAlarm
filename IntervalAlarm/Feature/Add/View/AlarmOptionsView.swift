//
//  AlarmOptionsView.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/2/24.
//
import SwiftUI
import ComposableArchitecture

struct AlarmOptionsView: View {

    @Perception.Bindable var store: StoreOf<AddAlarmFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .center, spacing: 10) {
                Toggle(isOn: $store.alarm.snooze.isOn.sending(\.didToggleSnooze)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("다시 울림")
                            .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                            .foregroundStyle(.grey100)
                        Text(store.alarm.snooze.isOn ? store.alarm.snooze.displayTitle : "사용 안함")
                            .font(Fonts.Pretendard.regular.swiftUIFont(size: 13))
                            .foregroundStyle(.grey80)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .grey90))
                .padding(20)
                .background(.white100)
                .cornerRadius(12)
                
                Toggle(isOn: $store.alarm.sound.isOn.sending(\.didToggleSound)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("알람음 설정")
                            .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                            .foregroundStyle(.grey100)
                        Text(store.alarm.sound.isOn ? store.alarm.sound.title : "사용 안함")
                            .font(Fonts.Pretendard.regular.swiftUIFont(size: 13))
                            .foregroundStyle(.grey80)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .grey90))
                .padding(20)
                .background(.white100)
                .cornerRadius(12)
            }
        }
    }
    
}

#Preview {
    AlarmOptionsView(store: .init(initialState: AddAlarmFeature.State(), reducer: {
        AddAlarmFeature()
    }))
}

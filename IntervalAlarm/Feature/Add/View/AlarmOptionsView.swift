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
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ring Again")
                            .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                            .foregroundStyle(.grey100)
                        Text(store.alarm.snooze.isOn ? store.alarm.snooze.displayTitle : Constants.notUsed)
                            .font(Fonts.Pretendard.regular.swiftUIFont(size: 13))
                            .foregroundStyle(.grey80)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        store.send(.didToggleSnooze)
                    }, label: {
                        store.alarm.snooze.isOn ? Images.toggleOn.swiftUIImage : Images.toggleOff.swiftUIImage
                    })
                    .buttonStyle(.plain)
                }
                .padding(20)
                .background(.white100)
                .cornerRadius(12)
                .onTapGesture {
                    store.send(.toSnoozeOption)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sound")
                            .font(Fonts.Pretendard.bold.swiftUIFont(size: 16))
                            .foregroundStyle(.grey100)
                        Text(store.alarm.sound.isOn ? store.alarm.sound.title : Constants.notUsed)
                            .font(Fonts.Pretendard.regular.swiftUIFont(size: 13))
                            .foregroundStyle(.grey80)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        store.send(.didToggleSound)
                    }, label: {
                        store.alarm.sound.isOn ? Images.toggleOn.swiftUIImage : Images.toggleOff.swiftUIImage
                    })
                    .buttonStyle(.plain)
                }
                .padding(20)
                .background(.white100)
                .cornerRadius(12)
            }
        }
    }
    
}

private extension AlarmOptionsView {
    
    enum Constants {
        static let notUsed: LocalizedStringKey = "Not in use"
    }
    
}

#Preview {
    AlarmOptionsView(store: .init(initialState: AddAlarmFeature.State(), reducer: {
        AddAlarmFeature()
    }))
}

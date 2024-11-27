//
//  ListModifier.swift
//  IntervalAlarm
//
//  Created by D프로젝트노드_오지연 on 11/26/24.
//

import SwiftUI

struct ListModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets())
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
    }
    
}

extension View {
    
    func noneSeperator() -> some View {
        return self.modifier(ListModifier())
    }
    
}

#Preview {
    List(1...10, id: \.self) { item in
        Text("\(item)")
            .noneSeperator()
    }
}

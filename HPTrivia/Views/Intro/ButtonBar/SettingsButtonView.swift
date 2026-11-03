//
//  SettingsButtonView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct SettingsButtonView: View {
    @State private var showSettings = false
    
    @Binding var animateViewsIn: Bool
    let geo: GeometryProxy
    
    var body: some View {
        Group {
            if animateViewsIn {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
                .transition(.offset(x: geo.size.height / 4))
            }
        }
        .animation(.easeOut(duration: 0.7), value: animateViewsIn)
    }
}

#Preview {
    GeometryReader { geo in
        SettingsButtonView(animateViewsIn: .constant(true), geo: geo)
    }
}

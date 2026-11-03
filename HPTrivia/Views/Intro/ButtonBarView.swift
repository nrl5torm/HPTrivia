//
//  ButtonBarView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct ButtonBarView: View {
    @Binding var animateViewsIn: Bool
    let geo: GeometryProxy
    
    var body: some View {
        HStack {
            Spacer()
            
            InstructionsButtonView(animateViewsIn: $animateViewsIn, geo: geo)
            
            Spacer()
            
            PlayButtonView(animateViewsIn: $animateViewsIn, geo: geo)
            
            Spacer()
            
            SettingsButtonView(animateViewsIn: $animateViewsIn, geo: geo)
            
            Spacer()
        }
        .frame(width: geo.size.width)
    }
}

#Preview {
    GeometryReader { geo in
        ButtonBarView(animateViewsIn: .constant(true), geo: geo)
    }
}

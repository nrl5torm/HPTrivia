//
//  AnimatedBackgroundView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct AnimatedBackgroundView: View {
    let geo: GeometryProxy
    
    var body: some View {
        Image(.hogwarts)
            .resizable()
            .frame(width: geo.size.width * 3)
            .padding(.top, 50)
            .phaseAnimator([0, -1, 0, 1]) { content, phase in
                content
                    .offset(x: geo.size.width * phase)
            } animation: { _ in
                    .linear(duration: 60)
            }
    }
}

#Preview {
    GeometryReader { geo in
        AnimatedBackgroundView(geo: geo)
    }
    .ignoresSafeArea()
}

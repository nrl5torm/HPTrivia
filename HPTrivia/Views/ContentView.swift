//
//  ContentView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3)
                    .phaseAnimator([false, true]) { content, phase in
                        content
                            .offset(x: phase ? geo.size.width : -geo.size.width)
                    } animation: { _ in
                            .linear(duration: 120)
                    }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .padding(.top, 50)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

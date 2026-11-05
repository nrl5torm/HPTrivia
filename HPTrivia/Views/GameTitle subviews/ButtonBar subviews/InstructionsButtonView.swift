//
//  InstructionsButtonView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct InstructionsButtonView: View {
    @State private var showInstructions = false

    @Binding var animateViewsIn: Bool
    let geo: GeometryProxy

    var body: some View {
        Group{
            if animateViewsIn {
                Button {
                    showInstructions.toggle()
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
                .transition(.offset(x: -geo.size.height / 4))
            }
        }
        .animation(.easeOut(duration: 0.7), value: animateViewsIn)
        .sheet(isPresented: $showInstructions) {
            InstructionsView()
        }
    }
}

#Preview {
    GeometryReader { geo in
        InstructionsButtonView(animateViewsIn: .constant(true), geo: geo)
    }
}

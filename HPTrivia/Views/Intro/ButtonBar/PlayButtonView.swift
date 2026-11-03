//
//  PlayButtonView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct PlayButtonView: View {
    @State private var showGame = false
    @State private var scalePlayButton = false
    
    @Binding var animateViewsIn: Bool
    let geo: GeometryProxy
    
    var body: some View {
        Group {
            if animateViewsIn {
                Button {
                    showGame.toggle()
                    //TODO
                    //audioPlayer?.stop()
                } label: {
                    Text("Play")
                        .font(.custom("PartyLetPlain", size: 50))
                        .padding(.top, 5)
                        .padding(.bottom, -10)
                        .padding(.horizontal)
                }
                .buttonStyle(.glassProminent)
                .shadow(radius: 5)
                .scaleEffect(scalePlayButton ? 1.2 : 1)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1.5)
                        .repeatForever()) {
                            scalePlayButton = true
                        }
                }
                .transition(.offset(y: geo.size.height / 2))
            }
        }
    }
}

#Preview {
    GeometryReader { geo in
        PlayButtonView(animateViewsIn: .constant(true), geo: geo)
    }
}

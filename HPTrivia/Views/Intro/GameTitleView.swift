//
//  GameTitleView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct GameTitleView: View {
    @Binding var animateViewsIn: Bool
    
    var body: some View {
        Group {
            if animateViewsIn {
                VStack {
                    Group {
                        Text("HarryPotter")
                            .font(.custom("PartyLetPlain", size: 72))
                            .shadow(color: .white, radius: 2)
                            .shadow(color: .white, radius: 5)
                        
                        Text("Trivia")
                            .font(.custom("PartyLetPlain", size: 60))
                            .shadow(color: .white, radius: 2)
                            .shadow(color: .white, radius: 5)
                        
                        Text("⚡️")
                            .font(.system(size: 100))
                            .shadow(radius: 5)
                    }
                }
                .transition(.move(edge: .top))
            }
        }
        .animation(.easeOut(duration: 0.7), value: animateViewsIn)
    }
}

#Preview {
    GameTitleView(animateViewsIn: .constant(true))
}

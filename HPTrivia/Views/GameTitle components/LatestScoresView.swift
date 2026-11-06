//
//  LatestScoresView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct LatestScoresView: View {
    @Environment(GameViewModel.self) private var game
    
    @Binding var animateViewsIn: Bool
    
    var body: some View {
        
        VStack {
            if animateViewsIn {
                VStack {
                    Text("Latest Scores:")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 2)
                    
                    ForEach(game.latestScores) { score in
                        Text("\(score.name) \(score.points)").padding(.bottom, 2)
                    }
                }
                .font(.title3)
                .padding(25)
                .glassEffect(in: .rect(cornerRadius: 40))
                .shadow(radius: 5)
                .transition(.scale)
            }
        }
        .animation(.easeOut(duration: 1), value: animateViewsIn)
    }
}

#Preview {
    LatestScoresView(animateViewsIn: .constant(true))
        .environment(GameViewModel())
}

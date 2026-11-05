//
//  GamePlayView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 05/11/2026.
//

import SwiftUI

struct GamePlayView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                
                VStack {
                    // MARK: Controls
                    
                    // MARK: Question
                    
                    // MARK: Hints
                    
                    // MARK: Answers
                }
                //.frame(width: geo.size.width, height: geo.size.height)
                
                // MARK: Celebration
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .padding(.top)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GamePlayView()
}

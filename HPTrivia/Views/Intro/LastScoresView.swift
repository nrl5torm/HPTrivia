//
//  LastScoresView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import SwiftUI

struct LastScoresView: View {
    @Binding var animateViewsIn: Bool
    
    var body: some View {
        
        VStack {
            if animateViewsIn {
                VStack {
                    Text("Last Scores")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 2)
                    
                    Text("Oscar 33").padding(.bottom, 2)
                    Text("Mary 27").padding(.bottom, 2)
                    Text("Henry 11").padding(.bottom, 2)
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
    LastScoresView(animateViewsIn: .constant(true))
}

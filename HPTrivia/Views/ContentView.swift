//
//  ContentView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var animateViewsIn = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
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
                
                VStack {
                    Group {
                        if animateViewsIn {
                            VStack {
                                Image(systemName: "bolt.fill")
                                    .imageScale(.large)
                                    .font(.largeTitle)
                                
                                Text("HarryPotter")
                                    .font(.custom("PartyLetPlain", size: 72))
                                    .padding(.bottom, -50)
                                    .shadow(color: .white, radius: 10)
                                
                                Text("Trivia")
                                    .font(.custom("PartyLetPlain", size: 60))
                                    .shadow(color: .white, radius: 10)
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                        
                        Spacer()
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .padding(.top)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
        }
    }
}

#Preview {
    ContentView()
}

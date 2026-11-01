//
//  IntroView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

import SwiftUI
import AVKit

struct IntroView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var scalePlayButton = false
    
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
//                                Image(systemName: "bolt.fill")
//                                    .imageScale(.large)
//                                    .font(.largeTitle)
                                
                                Text("HarryPotter")
                                    .font(.custom("PartyLetPlain", size: 72))
//                                    .padding(.bottom, -50)
                                    .shadow(color: .white, radius: 10)
                                
                                Text("Trivia")
                                    .font(.custom("PartyLetPlain", size: 60))
                                    .shadow(color: .white, radius: 10)
                                
                                Text("⚡️")
                                    .font(.system(size: 140))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                        
                        Spacer()
                        
                        Group {
                            if animateViewsIn {
                                Button("Play     ") {
                                    audioPlayer.stop()
                                    //TODO
                                }
                                .font(.largeTitle)
                                .buttonStyle(.glass)
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
                                 
                                Spacer()
                            }
                        }
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
            playAudio()
        }
    }
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
//        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}

#Preview {
    IntroView()
}

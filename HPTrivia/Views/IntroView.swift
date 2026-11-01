//
//  IntroView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

import SwiftUI
import AVKit

struct IntroView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var animateViewsIn = false
    @State private var scalePlayButton = false
    @State private var showInstructions = false
    @State private var showSettings = false
    
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
                                Group {
                                    Text("HarryPotter")
                                        .font(.custom("PartyLetPlain", size: 72))
                                        .shadow(color: .white, radius: 2)
                                        .shadow(color: .white, radius: 5)
                                    
                                    Text("Trivia")
                                        .font(.custom("PartyLetPlain", size: 60))
                                        .shadow(color: .white, radius: 2)
                                        .shadow(color: .white, radius: 5)
                                }
                                
                                Text("⚡️")
                                    .font(.system(size: 140))
                                    .shadow(radius: 5)
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                        
                        Spacer()
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
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
                                }
                            }
                            .transition(.offset(x: -geo.size.height / 4))
                            
                            Spacer()
                            
                            Group {
                                if animateViewsIn {
                                    Button("Play     ") {
                                        //TODO
                                        if let ap = audioPlayer {
                                            ap.stop()
                                        }
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
                                }
                            }
                            .transition(.offset(y: geo.size.height / 2))
                            
                            Spacer()
                            
                            Group {
                                if animateViewsIn {
                                    Button {
                                        showSettings.toggle()
                                    } label: {
                                        Image(systemName: "gearshape.fill")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                            .shadow(radius: 5)
                                    }
                                }
                            }
                            .transition(.offset(x: geo.size.height / 4))
                            
                            Spacer()
                        }
                        .frame(width: geo.size.width)
                        
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
//            playAudio()
        }
        .sheet(isPresented: $showInstructions) {
            InstructionsView()
        }
    }
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        let ap = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        ap.prepareToPlay()
        ap.play()
        audioPlayer = ap
    }
}

#Preview {
    IntroView()
}

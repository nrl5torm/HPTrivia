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
                                    .font(.system(size: 100))
                                    .shadow(radius: 5)
                            }
                            .padding()
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                VStack {
                                    Text("Last Scores")
                                        .font(.title2)
                                        .bold()
                                    
                                    Text("Oliv 33")
                                    Text("M 27")
                                    Text("Olv 11")
                                }
                                .font(.title3)
                                .padding(.vertical)
                                .padding(.horizontal, 25)
                                .glassEffect(in: .rect(cornerRadius: 20))
                                .shadow(radius: 5)
                                .transition(.opacity)
                            }
                        }
                        .animation(.linear(duration: 3).delay(2), value: animateViewsIn)
                        
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
                                    Button {
                                        //TODO
                                        audioPlayer?.stop()
                                        
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
        }
        .task {
            await startAudio()
        }
        .sheet(isPresented: $showInstructions) {
            InstructionsView()
        }
    }
    
    private func startAudio() async {
        let file = "magic-in-the-air"
        guard let sound = Bundle.main.path(forResource: file, ofType: "mp3") else {
            print("missing file \(file)")
            return
        }
        
        do {
            let ap = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            Task {
                ap.prepareToPlay()
                ap.play()
                audioPlayer = ap
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    IntroView()
}

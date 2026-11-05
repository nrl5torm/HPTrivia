//
//  GameTitleView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

import SwiftUI
import AVKit

struct GameTitleView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var animateViewsIn = false
    @State private var playingGame = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedBackgroundView(geo: geo)
                
                VStack {
                    Group {
                        Spacer()
                        
                        TitleView(animateViewsIn: $animateViewsIn)
                        
                        Spacer()
                        
                        LatestScoresView(animateViewsIn: $animateViewsIn)
                        
                        Spacer()
                        
                        ButtonBarView(animateViewsIn: $animateViewsIn, playingGame: $playingGame, geo: geo)
                        
                        Spacer()
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .padding(.top)
        }
        .ignoresSafeArea()
        .task {
            await startAudio()
            await startAnimation(delayedBySeconds: 1.5)
        }
        .fullScreenCover(isPresented: $playingGame) {
            GamePlayView()
                .onAppear() {
                    audioPlayer?.setVolume(0, fadeDuration: 2)
                }
                .onDisappear() {
                    audioPlayer?.setVolume(100, fadeDuration: 2)
                }
        }
    }
    
    private func startAnimation(delayedBySeconds delay: Double) async {
        do {
            try await Task.sleep(for: .seconds(delay))
        } catch {
            print(error.localizedDescription)
        }
        
        animateViewsIn = true
    }
    
    private func startAudio() async {
        let soundFile = "magic-in-the-air"
        
        guard let sound = Bundle.main.path(forResource: soundFile, ofType: "mp3") else {
            print("missing sound file \(soundFile)")
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
    GameTitleView()
        .environment(GameViewModel())
}

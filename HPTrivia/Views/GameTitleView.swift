//
//  GameTitleView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

import SwiftUI
import AVFAudio

struct GameTitleView: View {
    @State private var musicPlayer: AVAudioPlayer?
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
            await startMusic()
            await startAnimation(delayedBySeconds: 1.5)
        }
        .fullScreenCover(isPresented: $playingGame) {
            GamePlayView()
                .onAppear {
                    Task { await stopMusic() }
                }
                .onDisappear {
                    Task { await startMusic() }
                }
        }
    }
    
    private func startAnimation(delayedBySeconds delay: Double) async {
        try? await Task.sleep(for: .seconds(delay))
        
        animateViewsIn = true
    }
    
    private func stopMusic() async {
        musicPlayer?.setVolume(0, fadeDuration: 2)
        try? await Task.sleep(for: .seconds(3))
        musicPlayer?.stop()
    }
    
    private func startMusic() async {
        let soundFile = "magic-in-the-air"
        
        guard let sound = Bundle.main.path(forResource: soundFile, ofType: "mp3") else {
            print("missing sound file \(soundFile)")
            return
        }
        
        var player: AVAudioPlayer
        do {
            player = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            musicPlayer = player
            
            Task.detached(priority: .background) {
                player.volume = 0.5
                player.prepareToPlay()
                player.play()
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

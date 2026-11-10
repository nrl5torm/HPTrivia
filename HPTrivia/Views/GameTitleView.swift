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
            await startAnimation(after: .seconds(1.5))
        }
        .fullScreenCover(isPresented: $playingGame) {
            GamePlayView()
                .onAppear {
                    Task { await pauseMusic(after: .seconds(1)) }
                }
                .onDisappear {
                    Task { await resumeMusic() }
                }
        }
    }
    
    private func startAnimation(after delay: Duration) async {
        do { try await Task.sleep(for: delay) }
        catch { return }
        
        animateViewsIn = true
    }
    
    private func pauseMusic(after delay: Duration) async {
        musicPlayer?.setVolume(0, fadeDuration: TimeInterval(delay.components.seconds))
    }
    
    private func resumeMusic() async {
        let player = musicPlayer
        Task.detached(priority: .background) {
            player?.play()
            player?.setVolume(0.5, fadeDuration: 2)
        }
    }
    
    private func startMusic() async {
        let soundFile = ["magic-in-the-air", "school-of-magic"].randomElement()!
        
        guard let sound = Bundle.main.path(forResource: soundFile, ofType: "mp3") else {
            print("missing sound file \(soundFile)")
            return
        }
        
        var player: AVAudioPlayer
        do {
            player = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            musicPlayer = player
            
            Task.detached(priority: .background) {
                player.volume = 0.1
                player.prepareToPlay()
                
                player.play()
                player.setVolume(0.5, fadeDuration: 5)
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

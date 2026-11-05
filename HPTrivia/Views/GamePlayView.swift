//
//  GamePlayView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 05/11/2026.
//

import SwiftUI
import AVFAudio

struct GamePlayView: View {
    @Environment(GameViewModel.self) private var game
    @Environment(\.dismiss) private var dismiss
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
    @State private var showError = false
    @State private var error: LocalizedError?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                
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
        .onAppear {
            do {
                try game.startGame()
            } catch {
                self.error = error as? LocalizedError
                showError = self.error != nil
            }
        }
        .task {
            await startMusic(after: 3)
        }
        .alert("Error detected", isPresented: $showError, presenting: error, actions: { _ in
            Button("OK") { dismiss() }
        }, message: { error in
            Text("\(error.localizedDescription)")
        })
    }
    
    private func startMusic(after seconds: Int = 0) async {
        let musicFiles = ["let-the-mystery-unfold",
                         "spellcraft",
                         "hiding-place-in-the-forest",
                         "deep-in-the-dell"]
        let musicFile = musicFiles.randomElement()!
        
        guard let music = Bundle.main.path(forResource: musicFile, ofType: "mp3") else {
            print("ERROR: missing sound file \(musicFile)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(filePath: music))
            musicPlayer = player
            
            Task.detached(priority: .background) {
                player.numberOfLoops = -1
                player.volume = 0.1
                player.prepareToPlay()
                
                try? await Task.sleep(for: .seconds(seconds))
                
                player.play()
            }
        } catch {
            print(error)
        }
    }
    
    private func playHintSFX() async {
        await playSFX(soundFile: "page-flip")
    }
    
    private func playWrongSFX() async {
        await playSFX(soundFile: "negative-beeps")
    }
    
    private func playCorrectSFX() async {
        await playSFX(soundFile: "magic-wand")
    }
    
    private func playSFX(soundFile: String) async {
        guard let sound = Bundle.main.path(forResource: soundFile, ofType: "mp3") else {
            print("ERROR: missing sound file \(soundFile)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            sfxPlayer = player
            Task.detached(priority: .userInitiated) {
                player.play()
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    GamePlayView()
        .environment(GameViewModel())
}

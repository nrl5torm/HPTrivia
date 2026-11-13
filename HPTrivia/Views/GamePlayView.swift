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
    @Namespace private var namespace
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
    @State private var showErrorAlert = false
    @State private var error: Error?
    
    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var showNextButton = false
    @State private var scaleNextButton = false
    @State private var showBigScore = false
    
    private let mp3 = "mp3"
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .padding(.top)

                VStack {
                    // MARK: Top controls
                    HStack {
                        Text("Score:")
                            .font(.title3)
                            .padding(.trailing, 20)
                        
                        Text("\(game.currentScore)")
                            .font(.title3)
                            .bold()
                            .scaleEffect(showBigScore ? 2 : 1.1)
                        
                        Spacer()
                        
                        Button {
                            game.endGame()
                            dismiss()
                        } label : {
                            Text("╳ End ")
                                .bold()
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.glassProminent)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 30)
                    
                    // MARK: Question
                    VStack {
                        if animateViewsIn {
                            Text(game.currentQuestion.question)
                                .font(.custom("PartyLetPlain", size: 50))
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.7)
                                .padding()
                                .transition(.scale)
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)
                    .opacity(tappedCorrectAnswer ? 0.1 : 1)

                    Spacer()
                    
                    // MARK: Hints
                    HStack {
                        Spacer()
                        
                        Group {
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundStyle(.accent)
                                    .transition(.offset(x: -geo.size.width / 2))
                                    .phaseAnimator([0, tappedCorrectAnswer ? 0 : 5]) { content, phase in
                                        content.rotationEffect(.degrees(-10 - phase))
                                    } animation: { _ in
                                        .easeInOut(duration: 0.7)
                                    }
                                    .onTapGesture {
                                        game.revealedHint()
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            revealHint = true
                                        }
                                        Task { await playHintSFX() }
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 720 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .offset(x: revealHint ? geo.size.width : 0)
                                    .opacity(revealHint ? 0 : 1)
                                    .overlay {
                                        Text(game.currentQuestion.hint)
                                            .frame(width: geo.size.width / 3)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .opacity(revealHint ? 1 : 0)
                                            .scaleEffect(revealHint ? 1.3 : 0.5)
                                    }
                            }
                        }
                        
                        Spacer(minLength: geo.size.width / 4)
                        
                        Group {
                            if animateViewsIn {
                                Image(systemName: "apple.books.pages.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundStyle(.accent)
                                    .transition(.offset(x: geo.size.width / 2))
                                    .phaseAnimator([0, tappedCorrectAnswer ? 0 : 5]) { content, phase in
                                        content.rotationEffect(.degrees(10 + phase))
                                    } animation: { _ in
                                        .easeInOut(duration: 0.7)
                                    }
                                    .onTapGesture {
                                        game.revealedHint()
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            revealBook = true
                                        }
                                        Task { await playHintSFX() }
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? 720 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .offset(x: revealBook ? -geo.size.width : 0)
                                    .opacity(revealBook ? 0 : 1)
                                    .overlay {
                                        Image(game.currentQuestion.bookName)
                                            .resizable()
                                            .scaledToFit()
                                            .opacity(revealBook ? 1 : 0)
                                            .scaleEffect(revealBook ? 1.4 : 0.5)
                                            .shadow(radius: 3)
                                    }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .animation(.easeInOut(duration: animateViewsIn ? 0.5 : 0).delay(animateViewsIn ? 1.8 : 0), value: animateViewsIn)
                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                    .disabled(tappedCorrectAnswer)

                    // MARK: Possible answers
                    Spacer()
                    
                    LazyVGrid(columns: [GridItem(spacing: -50), GridItem()]) {
                        ForEach(game.possibleAnswers.enumerated(), id: \.offset) { i, answer in
                            Group {
                                if animateViewsIn {
                                    Button {
                                        game.answer(correctly: answer.isCorrect)
                                        withAnimation(.easeOut(duration: 1)) {
                                            if answer.isCorrect {
                                                tappedCorrectAnswer = true
                                                withAnimation(.easeOut(duration: 3)) {
                                                    showBigScore = true
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    showNextButton = true
                                                }
                                            }
                                            game.possibleAnswers[i].alreadyTapped = true
                                        }
                                        Task {
                                            if answer.isCorrect {
                                                await playCorrectSFX()
                                            } else {
                                                await playWrongSFX()
                                            }
                                        }
                                    } label: {
                                        Text(answer.text)
                                            .tint(.primary)
                                            .padding(10)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .frame(width: geo.size.width / 2.5, height: geo.size.height / 9.75)
                                            .scaleEffect(tappedCorrectAnswer && answer.isCorrect ? 2 : 1)
                                            .matchedGeometryEffect(id: answer.isCorrect ? game.currentQuestion.id + 10 : answer.id, in: namespace)
                                    }
                                    .glassEffect(in: .rect(cornerRadius: 36))
                                    .disabled(answer.alreadyTapped || tappedCorrectAnswer)
                                    .transition(.asymmetric(
                                        insertion: .offset(y: geo.size.height / 3),
                                        removal: .opacity))
                                    .scaleEffect(answer.alreadyTapped && !answer.isCorrect ? 0.6 : 1)
                                    .sensoryFeedback(.error, trigger: !answer.isCorrect && answer.alreadyTapped)
                                }
                            }
                            .opacity(tappedCorrectAnswer ? 0.1 : 1)
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 0.5 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                    .layoutPriority(1)
                    
                    Spacer(minLength: 10)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                // MARK: Celebration
                VStack {
                    Spacer(minLength: geo.size.height / 3)

                    Group {
                        if tappedCorrectAnswer {
                            Text(game.currentQuestion.answer)
                                .padding(10)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .frame(width: geo.size.width / 2.5, height: geo.size.height / 9.75)
                                .scaleEffect(tappedCorrectAnswer ? 2 : 1)
                                .matchedGeometryEffect(id: game.currentQuestion.id + 10, in: namespace)
                            
                            Text(game.congratsMessage)
                                .font(.custom("PartyLetPlain", size: 60))
                                .foregroundStyle(.accent)
                                .shadow(color: .white, radius: 5)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.5)
                                .padding(20)
                                .padding(.top, 30)
                                .frame(height: geo.size.height / 4)
                                .transition(.offset(y: geo.size.height / 3))
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)

                    VStack {
                        if showNextButton {
                            Button {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showBigScore = false
                                    showNextButton = false
                                    scaleNextButton = false
                                }
                                
                                animateViewsIn = false
                                revealHint = false
                                revealBook = false

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    game.nextQuestion()
                                    tappedCorrectAnswer = false

                                    animateViewsIn = true
                                }
                            } label: {
                                Text("Next")
                                    .font(.largeTitle)
                                    .padding()
                            }
                            .buttonStyle(.glassProminent)
                            .scaleEffect(scaleNextButton ? 0.8 : 1)
                            .transition(.opacity)
                            .onAppear {
                                withAnimation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever()) {
                                        scaleNextButton = true
                                    }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: showNextButton ? 1 : 0.5), value: showNextButton)
                    
                    Spacer(); Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            do {
                try game.startGame()
            } catch {
                self.error = error 
                showErrorAlert = self.error != nil
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                animateViewsIn = true
            }
        }
        .onDisappear() {
            musicPlayer.setVolume(0, fadeDuration: 1)
        }
        .task {
            await playMusic(after: .seconds(3))
        }
        .alert("Error detected 🌩️", isPresented: $showErrorAlert, presenting: error, actions: { _ in
            Button("OK") { dismiss() }
        }, message: { error in
            Text("\(error.localizedDescription)")
        })
    }
    
    private func playHintSFX() async {
        await playSFX(soundFile: "page-flip")
    }
    
    private func playWrongSFX() async {
        await playSFX(soundFile: "lose-funny")
    }
    
    private func playCorrectSFX() async {
        await playSFX(soundFile: "magic-wand")
    }
    
    private func playSFX(soundFile: String) async {
        guard let sound = Bundle.main.path(forResource: soundFile, ofType: mp3) else {
            print("ERROR: missing sound file \(soundFile).\(mp3)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            player.volume = 0.5
            sfxPlayer = player
            
            Task.detached(priority: .userInitiated) {
                player.play()
            }
        } catch {
            print(error)
        }
    }
    
    private func playMusic(after delay: Duration) async {
        let musicFiles = ["let-the-mystery-unfold",
                          "spellcraft",
                          "hiding-place-in-the-forest",
                          "deep-in-the-dell"]
        let musicFile = musicFiles.randomElement()!
        
        guard let music = Bundle.main.path(forResource: musicFile, ofType: mp3) else {
            print("ERROR: missing sound file \(musicFile).\(mp3)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(filePath: music))
            musicPlayer = player
            
            player.numberOfLoops = -1
            player.volume = 0.2
            
            Task.detached(priority: .background) {
                player.prepareToPlay()
                
                do { try await Task.sleep(for: delay) }
                catch { return }
                
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

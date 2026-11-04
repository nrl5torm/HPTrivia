//
//  SettingsView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 04/11/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Game.self) private var game
    
    @State private var showTmpAlert = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .background(.brown)
                .frame(width: 0)
            
            VStack {
                Text("Which books would you like to see questions from?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(game.questions.books) { book in
                            
                            switch book.status {
                            case .active:
                                ZStack(alignment: .bottomTrailing) {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.accent)
                                        .shadow(radius: 3)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    game.questions.updateStatusOfBook(id: book.id, to: .inactive)
                                }
                                
                            case .inactive:
                                ZStack(alignment: .bottomTrailing) {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay {
                                            Rectangle().opacity(0.4)
                                        }
                                    
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.accent.opacity(0.8))
                                        .shadow(radius: 3)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    game.questions.updateStatusOfBook(id: book.id, to: .active)
                                }
                                
                            case .locked:
                                ZStack {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay {
                                            Rectangle().opacity(0.8)
                                        }
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.accent.opacity(0.8))
                                        .shadow(color: .white, radius: 1)
                                }
                                .onTapGesture {
                                    showTmpAlert.toggle()
                                    
                                    game.questions.updateStatusOfBook(id: book.id, to: .active)
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 90)
                }
            }
            .foregroundStyle(.black)
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.custom("PartyLetPlain", size: 45))
                    .padding(.top, 10)
                    .padding(.horizontal)
            }
            .buttonStyle(.glass)
        }
        .alert("Thank you for purchasing this new question pack!", isPresented: $showTmpAlert) {}
    }
}

#Preview {
    SettingsView()
        .environment(Game())
}

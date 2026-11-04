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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .background(.brown)
                .frame(width: 0)
            
            VStack {
                Text("Settings")
                    .font(.custom("PartyLetPlain", size: 72))
                    .padding(10)
                
                Text("Which books would you like to see questions from?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(game.questions.books) { book in
                            if book.status == .active {
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
                            } else if book.status == .inactive {
                                ZStack {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                }
                            } else {
                                ZStack {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
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
    }
}

#Preview {
    SettingsView()
        .environment(Game())
}

//
//  SettingsView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 04/11/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GameViewModel.self) private var game
    
    @State private var showTmpAlert = false
    
    private var anyActiveBook: Bool {
        game.books.contains { book in
            book.status == .active
        }
    }
    
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
                    .padding(.bottom, 5)
                
                Text("You must select at least one book.")
                    .multilineTextAlignment(.center)
                    .bold()
                    .opacity(anyActiveBook ? 0 : 1)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(game.books) { book in
                            switch book.status {
                                
                            case .active:
                                ActiveBookView(book: book)
                                .onTapGesture {
                                    game.changeStatusOf(book: book.id, to: .inactive)
                                }
                                
                            case .inactive:
                                InactiveBookView(book: book)
                                .onTapGesture {
                                    game.changeStatusOf(book: book.id, to: .active)
                                }
                                
                            case .locked:
                                LockedBookView(book: book)
                                .onTapGesture {
                                    showTmpAlert.toggle()
                                    
                                    game.changeStatusOf(book: book.id, to: .active)
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
            .disabled(!anyActiveBook)
        }
        .interactiveDismissDisabled(!anyActiveBook)
        .alert("Thank you for purchasing this new question pack!", isPresented: $showTmpAlert) {}
    }
}

#Preview {
    SettingsView()
        .environment(GameViewModel())
}

//
//  LockedBookView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 05/11/2026.
//

import SwiftUI

struct LockedBookView: View {
    let book: Book

    var body: some View {
        ZStack {
            Image(book.imageName)
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
    }
}

#Preview {
    LockedBookView(book: DecodedQuestions().books.first!)
}

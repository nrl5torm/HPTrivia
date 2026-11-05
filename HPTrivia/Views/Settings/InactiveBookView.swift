//
//  InactiveBookView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 05/11/2026.
//

import SwiftUI

struct InactiveBookView: View {
    let book: Book

    var body: some View {
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
    }
}

#Preview {
    InactiveBookView(book: DecodedQuestions().books.first!)
}

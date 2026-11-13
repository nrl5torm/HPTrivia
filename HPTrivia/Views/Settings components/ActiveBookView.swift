//
//  ActiveBookView.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 05/11/2026.
//

import SwiftUI

struct ActiveBookView: View {
    let book: Book
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(book.imageName)
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
    }
}

#Preview {
    ActiveBookView(book: DecodedQuestions().books.first!)
}

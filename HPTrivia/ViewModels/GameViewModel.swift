//
//  GameViewModel.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 04/11/2026.
//

import SwiftUI

@Observable
class GameViewModel {
    public var books = DecodedQuestions().books
    
    public func changeStatusOf(book id: Int, to status: Book.Status) {
        books[id - 1].status = status
    }
}

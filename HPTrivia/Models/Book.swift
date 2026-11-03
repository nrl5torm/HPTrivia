//
//  Book.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

struct Book: Identifiable {
    let id: Int
    
    let image: String
    let questions: [Question]
    
    var status: BookStatus
    
    enum BookStatus {
        case active, inactive, locked
    }
}

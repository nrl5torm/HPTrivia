//
//  Question.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

struct Question: Decodable {
    let id: Int

    let question: String
    let answer: String
    let wrong: [String]

    let book: Int
    public var bookName: String {
        "hp\(String(book))"
    }
    
    let hint: String
    
    static public var none: Question {
        Question(id: 0, question: "", answer: "", wrong: [], book: 0, hint: "")
    }
}

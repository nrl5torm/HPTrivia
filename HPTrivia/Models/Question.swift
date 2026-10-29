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
    let wrongAnswers: [String]

    let book: Int
    let hint: String
}

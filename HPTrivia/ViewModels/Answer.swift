//
//  Answer.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 08/11/2026.
//


import SwiftUI

public struct Answer: Identifiable {
    public let id: Int
    public let text: String
    public let isCorrect: Bool

    public var alreadyTapped: Bool
    
    init(id: Int, text: String, correct: Bool = false) {
        self.id = id
        self.text = text
        self.isCorrect = correct
        self.alreadyTapped = false
    }
    
    public static func correct(id: Int, text: String) -> Answer {
        return Answer(id: id, text: text, correct: true)
    }
}

//
//  GameViewModel.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 04/11/2026.
//

import SwiftUI

@Observable
class GameViewModel {
    public var userName = "Harry"
    
    private(set) var gamePoints = 0
    private(set) var currentQuestionPoints = 0
    private(set) var latestScores = [
        Score(name: "Hermione", points: 20),
        Score(name: "Ron", points: 11),
        Score(name: "Harry", points: 15)
    ]
    
    private(set) var books = DecodedQuestions().books
    private(set) var activeQuestions: [Question] = []
    private(set) var doneQuestionIds: [Int] = []
    private(set) var currentQuestion = Question.none
    private(set) var answers: [String] = []
    
    public func startGame() throws {
        doneQuestionIds = []
        
        activeQuestions = Array(books.filter { book in
            book.status == .active
        }.map { book in
            book.questions
        }.joined())
        
        guard activeQuestions.count > 0 else {
            throw GameError.NoQuestionsFound
        }
        
        setNewQuestion()
    }
    
    private func setNewQuestion() {
        if doneQuestionIds.count == activeQuestions.count {
            doneQuestionIds = []
        }
        
        currentQuestion = activeQuestions.filter { question in
            !doneQuestionIds.contains(question.id)
        }.randomElement()!
        
        answers = [currentQuestion.answer]
        answers.append(contentsOf: currentQuestion.wrong)
        answers.shuffle()
        
        currentQuestionPoints = 5
    }
    
    public func answer(correctly: Bool) {
        if correctly {
            doneQuestionIds.append(currentQuestion.id)
            gamePoints += currentQuestionPoints
            
            setNewQuestion()
        } else {
            gamePoints -= 1
        }
    }
    
    public func endGame() {
        latestScores[2] = latestScores[1]
        latestScores[1] = latestScores[0]
        latestScores[0] = Score(name: userName, points: gamePoints)
        
        gamePoints = 0
        activeQuestions = []
    }
    
    public func changeStatusOf(book id: Int, to status: Book.Status) {
        books[id - 1].status = status
    }
}

public struct Score {
    let name: String
    let points: Int
}

public enum GameError: Int, Error {
    case NoQuestionsFound = 1
}

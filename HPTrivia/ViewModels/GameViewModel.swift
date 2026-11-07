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
    
    private(set) var currentScore = 0
    private(set) var currentQuestionPoints = 0
    
    private(set) var latestScores = [
        Score(id: 5, name: "Hermione", points: 112),
        Score(id: 6, name: "Ron", points: 50),
        Score(id: 7, name: "Harry", points: 77)
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
            throw GameError.noQuestionsFound
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
            currentScore += currentQuestionPoints
            
            setNewQuestion()
        } else {
            currentQuestionPoints -= 1
        }
    }
    
    public func endGame() {
        latestScores[2] = latestScores[1]
        latestScores[1] = latestScores[0]
        latestScores[0] = Score(id: latestScores[0].id - 1, name: userName, points: currentScore)
        
        currentScore = 0
        activeQuestions = []
    }
    
    public func changeStatusOf(book id: Int, to status: Book.Status) {
        books[id - 1].status = status
    }
}

public enum GameError: Int, LocalizedError {
    case noQuestionsFound = 1
    
    public var errorDescription: String? {
        switch self {
        case .noQuestionsFound:
            "No questions found. Please update, or uninstall then reinstall the app to recover the missing data.\nSorry :("
        }
    }
}

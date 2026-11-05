//
//  DecodedQuestions.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import Foundation

@Observable
class DecodedQuestions {
    var books: [Book] = []
    
    init() {
        let decodedQuestions = decodeQuestions()
        let organizedQuestions = organizeQuestions(decodedQuestions)
        populateBooks(with: organizedQuestions)
    }
    
    private func decodeQuestions() -> [Question] {
        let file = "trivia-en"
        var decodedQuestions: [Question] = []
        
        do {
            guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
                throw DecodingError.missingFile(name: "\(file).json")
            }
            
            let data = try Data(contentsOf: url)
            decodedQuestions = try JSONDecoder().decode([Question].self, from: data)
            
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedQuestions
    }
    
    private func organizeQuestions(_ questions: [Question]) -> [[Question]] {
        var organizedQuestions: [[Question]] = Array(repeating: [], count: 7)
        
        for question in questions {
            organizedQuestions[question.book - 1].append(question)
        }
        
        return organizedQuestions
    }
    
    private func populateBooks(with questions: [[Question]]) {
        for i in (1...questions.count) {
            books.append(
                Book(id: i,
                     image: "hp\(i)",
                     questions: questions[i - 1],
                     status: i <= 2 ? .active : (i <= 3 ? .inactive : .locked)))
        }
    }
    
    enum DecodingError: LocalizedError {
        case missingFile(name: String)
        
        public var errorDescription: String? {
            switch self {
            case .missingFile(let file):
                "Cannot decode missing file: \(file)."
            }
        }
    }
}

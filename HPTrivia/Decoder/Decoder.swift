//
//  Decoder.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

import Foundation

@Observable
class Decoder {
    var decodedBooks: [Book] = []
    
    private let saveURL = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!.appending(path: "books.json")
    
    init() {
        loadBooks()
    }
    
    public func saveBooks() {
        do {
            let data = try JSONEncoder().encode(decodedBooks)
            try data.write(to: saveURL)
        } catch {
            print("Error: unable to save book status data. \(error)")
        }
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
            decodedBooks.append(
                Book(id: i,
                     imageName: "hp\(i)",
                     questions: questions[i - 1],
                     status: i <= 2 ? .active : (i <= 3 ? .inactive : .locked)))
        }
    }
    
    private func loadBooks() {
        do {
            let data = try Data(contentsOf: saveURL)
            decodedBooks = try JSONDecoder().decode([Book].self, from: data)
        } catch {
            print("INFO: no saved book status data. \(error)")
            
            let decodedQuestions = decodeQuestions()
            let organizedQuestions = organizeQuestions(decodedQuestions)
            populateBooks(with: organizedQuestions)
        }
    }
}

//
//  Book.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 03/11/2026.
//

struct Book: Codable, Identifiable {
    let id: Int
    
    let imageName: String
    let questions: [Question]
    var status: Status
    
    enum Status: Codable {
        case active, inactive, locked
    }
}

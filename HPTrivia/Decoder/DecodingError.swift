//
//  DecodingError.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 13/11/2026.
//


import Foundation

enum DecodingError: LocalizedError {
        case missingFile(name: String)
        
        public var errorDescription: String? {
            switch self {
            case .missingFile(let file):
                "Cannot decode missing file: \(file)."
            }
        }
    }
//
//  Score.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 06/11/2026.
//


import SwiftUI

public struct Score: Codable, Identifiable {
    public let id: Int
    
    let name: String
    let points: Int
}

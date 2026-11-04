//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 29/10/2026.
//

import SwiftUI

@main
struct HPTriviaApp: App {
    private var game = Game()
    
    var body: some Scene {
        WindowGroup {
            IntroView()
                .environment(game)
        }
    }
}

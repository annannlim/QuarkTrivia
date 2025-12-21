//
//  TriviaApp.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import SwiftUI

@main
struct TriviaApp: App {
    
    @StateObject private var gameVM = GameVM(repo: QuestionRepository())
    
    var body: some Scene {
        WindowGroup {
            Main(gameVM: gameVM)
        }
    }

    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
            .tintColor = UIColor(named: "AccentColor")
            
    }
}

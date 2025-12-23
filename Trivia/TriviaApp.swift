//
//  TriviaApp.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import SwiftUI

@main
struct TriviaApp: App {
    
    @State private var gameVM = GameVM()
    
    var body: some Scene {
        WindowGroup {
            Main()
                .environment(gameVM)
        }
    }

    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
            .tintColor = UIColor(named: "AccentColor")
            
    }
}

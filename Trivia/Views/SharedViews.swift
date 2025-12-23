//
//  Shared.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import SwiftUI

struct BackgroundParchment: View {
    var body: some View {
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}


extension Button {
    @MainActor func doneButton() -> some View {
        self.font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundColor(.white)
    }
}

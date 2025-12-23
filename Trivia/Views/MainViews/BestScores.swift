//
//  BestScores.swift
//  Trivia
//
//  Created by Annabel Lim on 12/21/25.
//

import SwiftUI

struct BestScores: View {
    
    @Environment(GameVM.self) private var gameVM
    @Binding var animateViewsIn: Bool
    @State var showFetchError: Bool

    var body: some View {
        VStack {
            if animateViewsIn {
                VStack {
                    Text("Best Scores")
                        .font(.title2)
                    Text("Easy Level: " + String(gameVM.highestScores[0]) + " %")
                    Text("Moderate Level: " + String(gameVM.highestScores[1]) + " %")
                    Text("Difficult Level: " + String(gameVM.highestScores[2]) + " %")
                }
                .font(.title3)
                .padding(.horizontal)
                .padding()
                .foregroundColor(.white)
                .background(.black.opacity(0.7))
                .cornerRadius(15)
                .transition(.opacity)
            }
        }
        .animation(.linear(duration: 1).delay(3.5), value: animateViewsIn)
        .opacity(showFetchError ? 0: 1)
        
    }
}

#Preview {
    BestScores(animateViewsIn: .constant(true), showFetchError: false)
        .environment(GameVM())
}

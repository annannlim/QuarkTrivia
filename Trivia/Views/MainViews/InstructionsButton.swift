//
//  InfoButton.swift
//  Trivia
//
//  Created by Annabel Lim on 12/21/25.
//

import SwiftUI

struct InstructionsButton: View {
    
    @State private var showInstructions = false
    @Binding var animateViewsIn: Bool
    let geo: GeometryProxy
    
    var body: some View {
        
        VStack {
            if animateViewsIn {
                Button {
                    // Show instructions screen
                    showInstructions.toggle()
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 5)
                }
                .transition(.offset(x: -geo.size.width/4))
            }
        }
        .animation(.easeOut(duration:0.7).delay(2.7), value: animateViewsIn)
        .fullScreenCover(isPresented: $showInstructions) {
            Instructions()
        }
    }
}

#Preview {
    GeometryReader { geo in
        InstructionsButton(animateViewsIn: .constant(true), geo: geo)
            .frame(width: geo.size.width, height: geo.size.height)
    }
}

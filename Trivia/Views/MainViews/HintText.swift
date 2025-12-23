//
//  HintText.swift
//  Trivia
//
//  Created by Annabel Lim on 12/21/25.
//

import SwiftUI

struct HintText: View {
    
    @Binding var animateViewsIn: Bool
    @State var showFetchError: Bool
    
    var body: some View {

        VStack {
                if animateViewsIn {
                    VStack {
                        Text("Tap Settings ⚙️ below ↘️")
                        Text("to set your categories.")
                    }
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding()
                    .foregroundColor(.white)
                    .background(.black.opacity(0.7))
                    .cornerRadius(15)
                    .transition(.opacity)
                }
            }
            .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
            .opacity(showFetchError ? 0: 1)
            
            Spacer()
            
    }
}

#Preview {
    HintText(animateViewsIn: .constant(true), showFetchError: false)
        .environment(GameVM())
}

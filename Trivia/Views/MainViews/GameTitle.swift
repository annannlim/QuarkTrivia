//
//  GameTitle.swift
//  Trivia
//
//  Created by Annabel Lim on 12/21/25.
//

import SwiftUI

struct GameTitle: View {
    
    @Binding var animateViewsIn: Bool
    
    var body: some View {
        
        VStack {
            if animateViewsIn {
                VStack {
                    Image(ImageResource.appIconRounded)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .padding(.bottom, -20)
                    Text("Quark")
                        .font(.custom(K.MY_FONT, size: 70))
                        .padding(.bottom, -50)
                    Text("Trivia")
                        .font(.custom(K.MY_FONT, size: 60))
                        .padding(.bottom, -50)
                    
                }
                .foregroundColor(.white)
                .padding(.top, 160)
                .transition(.move(edge:.top))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
            
    }
}

#Preview {
    GameTitle(animateViewsIn: .constant(true))
}

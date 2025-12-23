//
//  PlayButton.swift
//  Trivia
//
//  Created by Annabel Lim on 12/21/25.
//

import SwiftUI

struct PlayButton: View {
    
    @Environment(GameVM.self) private var gameVM
    @State private var scalePlayButton = false
    @Binding var animateViewsIn: Bool
    @Binding var showFetchError: Bool
    @Binding var playGame : Bool
    
    let geo: GeometryProxy

    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    Task {
                        await gameVM.startGame()
                        switch gameVM.status {
                        case .Failure:
                            showFetchError = true
                        case .Success:
                            playGame.toggle()
                        default:
                            break
                        }
                    }
                } label: {
                    Text("Play")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 50)
                        .background(.brown)
                        .clipShape(.rect(cornerRadius: 7))
                        .shadow(radius: 5)
//                        .scaleEffect(scalePlayButton ? 1.2 : 1)
//                        .onAppear {
//                            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
//                                scalePlayButton.toggle()
//                            }
//                        }
                }
                .transition(.offset(y: geo.size.height/3))
                .phaseAnimator([false,true]) { content, phase in
                    content
                        .scaleEffect(phase ? 1.2 : 1)
                } animation: { _ in
                        .easeInOut(duration: 1.3)
                }

            }
        }
        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
    }
}

#Preview {
    GeometryReader { geo in
        PlayButton(animateViewsIn: .constant(true), showFetchError: .constant(false), playGame: .constant(true), geo: geo)
            .environment(GameVM())
    }
}

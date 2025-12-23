//
//  SettingsButton.swift
//  Trivia
//
//  Created by Annabel Lim on 12/21/25.
//

import SwiftUI

struct SettingsButton: View {
        
    @Environment(GameVM.self) private var gameVM
    @Binding var animateViewsIn: Bool
    @Binding var showSettings: Bool
    let geo: GeometryProxy
        
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 5)
                }
                .transition(.offset(x: geo.size.width/4))
            }
        }
        .animation(.easeOut(duration:0.7).delay(2.7), value: animateViewsIn)
        .fullScreenCover(isPresented: $showSettings) {
            Settings()
                .environment(gameVM)
                .onAppear() {
                    if (gameVM.mAudioPlayer != nil) {
                        gameVM.mAudioPlayer.setVolume(0,fadeDuration: 2)
                    }
                }
                .onDisappear() {
                    if (gameVM.mAudioPlayer != nil) {
                        if (gameVM.bMusicOn) {
                            gameVM.mAudioPlayer.setVolume(1, fadeDuration: 3)
                        } else {
                            gameVM.mAudioPlayer.setVolume(0, fadeDuration: 0)
                        }
                    }
                }
        }

    }
}

#Preview {
    GeometryReader { geo in
        SettingsButton(animateViewsIn: .constant(true), showSettings : .constant(true), geo: geo)
            .frame(width: geo.size.width, height: geo.size.height)
            .environment(GameVM())
    }
}


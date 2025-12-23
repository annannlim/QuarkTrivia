//
//  ContentView.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import SwiftUI
import AVKit

struct Main: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(GameVM.self) private var gameVM

    @State private var animateViewsIn = false
    @State private var playGame = false
    @State private var showSettings = false
    @State private var showFetchError = false
    
    var body: some View {

        GeometryReader { geo in
            ZStack {

                AnimatedBackground(geo: geo)

                VStack {
                    GameTitle(animateViewsIn: $animateViewsIn)
                    Spacer()
                    BestScores(animateViewsIn: $animateViewsIn, showFetchError: showFetchError)
                    Spacer()
                    if (gameVM.bSettingsSet == false ) {
                       HintText(animateViewsIn: $animateViewsIn, showFetchError: showFetchError)
                        Spacer()
                    }
                    
                    // PLAY GAME BUTTON BAR
                    HStack {
                        Spacer()
                        InstructionsButton(animateViewsIn: $animateViewsIn, geo: geo)
                        Spacer()
                        PlayButton( animateViewsIn: $animateViewsIn, showFetchError: $showFetchError, playGame: $playGame, geo: geo)
                        Spacer()
                        SettingsButton(animateViewsIn: $animateViewsIn, showSettings: $showSettings, geo: geo)
                        Spacer()
                    }
                    .frame(width: geo.size.width)
                    .padding(.bottom)
                    
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .statusBarHidden()
        .onAppear {
            animateViewsIn = true
            gameVM.mPlayAudio()
        }
        .fullScreenCover(isPresented: $playGame) {
            Gameplay()
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
        .alert("Oops! We are unable to retrieve questions from the internet at this time. Please try again later.", isPresented: $showFetchError) {
            Button("OK") { }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .background:
                Task {
                    gameVM.endGame()
                    if (!playGame) {
                        gameVM.mStopMusic()
                    } else {
                        gameVM.gStopMusic()
                    }
                    //print("TRACE App moved to Background: Not visible to the user")
                    // Save data to persistent storage, free up resources
                }
            case .inactive:
                print("TRACE App became Inactive: Foreground but not interactive (e.g., during a phone call)")
                // Pause timers, save non-critical state
            case .active:
                Task {
                    if (!playGame) {
                        if (!showSettings) {
                            gameVM.mStartMusic()
                        }
                    } else {
                        gameVM.gStartMusic()
                    }
                    //print("TRACE App became Active: Foreground and interactive")
                    // Resume tasks, refresh data
                }
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    Main()
        .environment(GameVM())
}

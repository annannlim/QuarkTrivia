//
//  ContentView.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import SwiftUI
import AVKit

struct Main: View {
    
    @ObservedObject var gameVM: GameVM
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    @State private var animateViewsIn = false
    @State private var showInstructions = false
    @State private var showSettings = false
    @State private var playGame = false
    @State private var showFetchError = false
    
    var body: some View {

        // put everything inside a geometry reader
        // so we know the width and height of the screen
        GeometryReader { geo in

            ZStack {
                
                AnimatedBackground(geo: geo)
                
                VStack {
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
                            .padding(.top, 120)
                            .transition(.move(edge:.top))
                        }
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    
                    Spacer()
                    VStack {
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
                    
                    Spacer()

                    if (!(gameVM.settingsSet ?? false) ) {
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
                    
                    // PLAY GAME
                    HStack {
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    // Show instructions screen
                                    showInstructions.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                }
                                .transition(.offset(x: -geo.size.width/4))
                                .fullScreenCover(isPresented: $showInstructions) {
                                    Instructions()
                                }
                            }
                        }
                        .animation(.easeOut(duration:0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    // Start new game
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
                                        .cornerRadius(7)
                                        .shadow(color: .black, radius: 5)
                                }
                                .scaleEffect(scalePlayButton ? 1.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height/3))
                                .fullScreenCover(isPresented: $playGame) {
                                    Gameplay(gameVM: gameVM)
                                        .onAppear() {
                                            if (audioPlayer != nil) {
                                                audioPlayer.setVolume(0,fadeDuration: 2)
                                            }
                                        }
                                        .onDisappear() {
                                            if (audioPlayer != nil) {
                                                if (gameVM.bMusicOn) {
                                                    audioPlayer.setVolume(1, fadeDuration: 3)
                                                } else {
                                                    audioPlayer.setVolume(0, fadeDuration: 0)
                                                }
                                            }
                                        }
                                }
                                    
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer()

                        VStack {
                            if animateViewsIn {
                                Button {
                                    // Show settings screen
                                    showSettings.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .shadow(color: .black, radius: 5)
                                }
                                .transition(.offset(x: geo.size.width/4))
                                .fullScreenCover(isPresented: $showSettings) {
                                    Settings(gameVM: gameVM)
                                        .onAppear() {
                                            if (audioPlayer != nil) {
                                                audioPlayer.setVolume(0,fadeDuration: 2)
                                            }
                                        }
                                        .onDisappear() {
                                            if (audioPlayer != nil) {
                                                if (gameVM.bMusicOn) {
                                                    audioPlayer.setVolume(1, fadeDuration: 3)
                                                } else {
                                                    audioPlayer.setVolume(0, fadeDuration: 0)
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .animation(.easeOut(duration:0.7).delay(2.7), value: animateViewsIn)

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
        .onAppear {
            animateViewsIn = true
            playAudio()
        }
        .alert("Oops! We are unable to retrieve questions from the internet at this time.", isPresented: $showFetchError) {
            Button("OK") { }
        }       
    }
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "trivia1", ofType: "mp3", inDirectory: "Sounds")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1
        if (gameVM.bMusicOn) {
            audioPlayer.volume = 1
        } else {
            audioPlayer.volume = 0
        }
        audioPlayer.play()
    }
}

#Preview {
    Main(gameVM: GameVM(repo: QuestionRepository()))
}

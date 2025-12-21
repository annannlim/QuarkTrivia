//
//  GamePlay.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import SwiftUI
import StoreKit
import AVKit

struct Gameplay: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) var requestReview
    
    @ObservedObject var gameVM : GameVM

    @Namespace private var namespace
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
    @State private var animateViewsIn = false
    @State private var tappedCorrectAnswer = false
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    @State private var wrongAnswersTapped: [String] = []
    @State private var showFetchError = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("backgroundBeach")
                    .resizable()
                    .frame(width:geo.size.width * 3, height: geo.size.height * 1.1)
                    .overlay(Rectangle().foregroundColor(.black.opacity(0.8)))
                    
                    VStack {
                        // MARK: Controls
                        HStack {
                            Button("End Game") {
                                gameVM.endGame()
                                dismiss()
                                //requestReview()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red.opacity(0.5))
                            Spacer()
                            Text("Score: \(gameVM.gameScore)")
                        }
                        .padding()
                        .padding(.top, 50)
                        
                        // MARK: Question
                        VStack {
                            if animateViewsIn {
                                Text(gameVM.questions[gameVM.idx].question)
                                    .minimumScaleFactor(0.5)
                                    .font(.custom(K.MY_FONT, size: 24))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .transition(.scale)
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                            }
                        }
                        .animation(.easeInOut(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)
                        
                        Spacer()
                        
                        // MARK: Answers
                        LazyVGrid(columns: [GridItem()]){
                            VStack {
                                if animateViewsIn {
                                    ForEach(gameVM.questions[gameVM.idx].allAnswers, id : \.self) { answer in
                                        if answer == gameVM.questions[gameVM.idx].correctAnswer {
                                            if tappedCorrectAnswer == false {
                                                Text(answer)
                                                    .minimumScaleFactor(0.5)
                                                    .multilineTextAlignment(.center)
                                                    .padding(10)
                                                    .frame(width: geo.size.width > 740 ? geo.size.width/1.75 : geo.size.width/1.15, height: 100)
                                                    .background(.green.opacity(0.5))
                                                    .cornerRadius(25)
                                                    .transition(.asymmetric(insertion: .scale, removal: .scale(scale:5).combined(with: .opacity.animation(.easeOut(duration:0.5)))))
                                                    .matchedGeometryEffect(id: "answer", in: namespace)
                                                    .onTapGesture {
                                                        withAnimation(.easeOut(duration: 1)) {
                                                            tappedCorrectAnswer = true
                                                        }
                                                        playCorrectSound()
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                                            withAnimation {
                                                                gameVM.gameScore += gameVM.questionScore
                                                            }
                                                        }
                                                    }
                                            }
                                        } else {
                                            Text(answer)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width > 740 ? geo.size.width/1.75 : geo.size.width/1.15, height: 100)
                                                .background(wrongAnswersTapped.contains(answer) ? .red.opacity(0.5): .green.opacity(0.5))
                                                .cornerRadius(25)
                                                .transition(.scale)
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration:1)) {
                                                        wrongAnswersTapped.append(answer)
                                                    }
                                                    playWrongSound()
                                                    giveWrongFeedback()
                                                    gameVM.questionScore -= 1
                                                }
                                                .scaleEffect(wrongAnswersTapped.contains(answer) ? 0.8 : 1)
                                                .disabled(tappedCorrectAnswer || wrongAnswersTapped.contains(answer))
                                                .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                        }
                                    }
                                }
                            }
                            .animation(.easeIn(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1 : 0), value: animateViewsIn)
                        }
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .foregroundColor(.white)
                
                // MARK: Celebration
                VStack {
                    
                    Spacer()
                    
                    VStack {
                        if tappedCorrectAnswer {
                            Text("\(gameVM.questionScore)")
                                .font(.largeTitle)
                                .padding(.top,50)
                                .transition(.offset(y: -geo.size.height/4))
                                .offset(x: movePointsToScore ? geo.size.width/2.3: 0, y: movePointsToScore ? -geo.size.height/13 : 50)
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).delay(2)) {
                                        movePointsToScore = true
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration:1).delay(1), value: tappedCorrectAnswer)

                    Spacer()
                    
                    VStack {
                                                
                        if tappedCorrectAnswer {
                            Text(gameVM.getComment())
                                .minimumScaleFactor(0.5)
                                .font(.custom(K.MY_FONT, size: 56))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height/2)))
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay( tappedCorrectAnswer ? 0.5 : 0 ), value: tappedCorrectAnswer)
                    
                    Spacer()


                    if tappedCorrectAnswer && !gameVM.isLastQuestion() {                        
                        Text(gameVM.questions[gameVM.idx].correctAnswer)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.3)
                            .padding(10)
                        .frame(width: geo.size.width > 740 ? geo.size.width/2 : geo.size.width/1.6, height: 100)
                        .background(.green.opacity(0.5))
                            .cornerRadius(25)
                            .scaleEffect(1.5)
                            .matchedGeometryEffect(id: "answer", in: namespace)
                    }

                    Spacer()
                    Spacer()
    
                    VStack {
                        if tappedCorrectAnswer {
                            if (gameVM.isLastQuestion()) {
                                Text("You scored \(gameVM.gameScore) out of \(K.QUESTIONS_PER_GAME * 5)!")
                                    .font(.largeTitle)
                                Button("Play Again?") {
                                    // Reset for next game
                                    gameVM.endGame()
                                    Task {
                                        await gameVM.startGame()
                                        switch gameVM.status {
                                        case .Failure:
                                            animateViewsIn = false
                                            tappedCorrectAnswer = false
                                            movePointsToScore = false
                                            wrongAnswersTapped = []
                                            showFetchError = true
                                            break
                                        case .Success:
                                            animateViewsIn = false
                                            tappedCorrectAnswer = false
                                            movePointsToScore = false
                                            wrongAnswersTapped = []
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                animateViewsIn = true
                                            }
                                            break
                                        default:
                                            break
                                        }
                                    }
                                   
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue.opacity(0.5))
                                .font(.largeTitle)
                                .transition(.offset(y:geo.size.height/3))
                                .scaleEffect(scaleNextButton ? 1.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scaleNextButton.toggle()
                                    }
                                }

                            } else {
                                
                                Button("Next Question") {
                                    // Reset level for next question
                                    animateViewsIn = false
                                    tappedCorrectAnswer = false
                                    movePointsToScore = false
                                    wrongAnswersTapped = []
                                    gameVM.nextQuestion()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        animateViewsIn = true
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue.opacity(0.5))
                                .font(.largeTitle)
                                .transition(.offset(y:geo.size.height/3))
                                .scaleEffect(scaleNextButton ? 1.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scaleNextButton.toggle()
                                    }
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 2 : 0 ).delay(tappedCorrectAnswer ? 2 : 0), value: tappedCorrectAnswer)
                    
                    Spacer()
                    Spacer()
                    
                }
                .foregroundColor(.white)

            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear() {
            animateViewsIn = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                playMusic()
            }
        }
        .alert("Oops! We are unable to retrieve questions from the internet at this time.", isPresented: $showFetchError) {
            Button("OK") { dismiss() }
        }

    }
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "failure", ofType: "mp3", inDirectory: "Sounds")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        if (gameVM.bSoundOn) {
            sfxPlayer.volume = 1
        } else {
            sfxPlayer.volume = 0
        }
        sfxPlayer.play()
    }
    
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "success", ofType: "mp3", inDirectory: "Sounds")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        if (gameVM.bSoundOn) {
            sfxPlayer.volume = 1
        } else {
            sfxPlayer.volume = 0
        }
        sfxPlayer.play()
    }
    
    private func giveWrongFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    private func playMusic() {
        let songs = ["trivia2","trivia3","trivia4","trivia5"]
        let i = Int.random(in: 0...3)
        let sound = Bundle.main.path(forResource: songs[i], ofType: "mp3", inDirectory: "Sounds")
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.numberOfLoops = -1
        if (gameVM.bMusicOn) {
            musicPlayer.volume = 0.1
        } else {
            musicPlayer.volume = 0
        }
        musicPlayer.play()
    }
}

//#Preview {
//    Gameplay(gameVM: GameVM(repo: QuestionRepository()))
//}

//
//  StaticData.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import SwiftUI
import AVKit

enum Status {
    case NotStarted
    case Fetching
    case Success
    case Failure
}

@MainActor
@Observable
class GameVM {
      
    // MARK: - Categories, Levels, Sound and Scores processing

//    @AppStorage(K.USER_DEFAULTS_SETTINGS_SET) var settingsSet : Bool?
//    @AppStorage(K.SOUND_ON) var soundOn : Bool = true
//    @AppStorage(K.MUSIC_ON) var musicOn : Bool = true
    
    var categories: [Category] = []
    var levels: [Level] = []
    var gameScore = 0
    var questionScore = 5
    var highestScores = [0,0,0]
    var bSoundOn = true
    var bMusicOn = true
    var bSettingsSet = UserDefaults.standard.bool(forKey: "K.USER_DEFAULTS_SETTINGS_SET")
    
    func saveSettings() {
        CategoryHelper().save(categories: categories)
        LevelHelper().save(levels: levels)
        UserDefaults.standard.set(bSoundOn, forKey: "K.SOUND_ON")
        UserDefaults.standard.set(bMusicOn, forKey: "K.MUSIC_ON")
        bSettingsSet = true
        UserDefaults.standard.set(true, forKey: "K.USER_DEFAULTS_SETTINGS_SET")
        let settingsSet  = UserDefaults.standard.bool(forKey: "K.USER_DEFAULTS_SETTINGS_SET")
        print("TRACE saveSettings called \(settingsSet)!")
    }
        
    func areSettingsValid() -> Bool {

        var hasOneCategory = false
        for cat in categories {
            if (cat.active) {
                hasOneCategory = true
                break
            }
        }

        var hasOneLevel = false
        for lvl in levels {
            if (lvl.active) {
                hasOneLevel = true
                break
            }
        }

        return hasOneCategory && hasOneLevel
    }

    // MARK: - Game Processing
        
    var status: Status = .NotStarted
    var questions : [Question] = []
    var idx : Int = 0
    
    func startGame() async {
        status = .Fetching
        await getQuestions()
        gameScore = 0
        questionScore = 5
        idx = 0
    }

    func endGame() {
        if levels[2].active == true {
            if gameScore > highestScores[2] {
                highestScores[2] = gameScore
            }
        } else if levels[1].active == true {
            if gameScore > highestScores[1] {
                highestScores[1] = gameScore
            }
        } else {
            if gameScore > highestScores[0] {
                highestScores[0] = gameScore
            }
        }
        ScoreHelper().saveScores(scores: highestScores)
        status = Status.NotStarted
    }

    func isLastQuestion() -> Bool{

        return idx == K.QUESTIONS_PER_GAME - 1
    }
    
    func nextQuestion() {
        if (idx < (K.QUESTIONS_PER_GAME - 1) ) {
            questionScore = 5
            idx += 1
        }
    }
    
    func getComment() -> String {
        if (questionScore == 5) {
            return "Outstanding!"
        } else if (questionScore == 4) {
            return "Excellent!"
        } else if (questionScore == 3) {
            return "Brilliant!"
        } else {
            return "Good Job!"
        }
    }

    
    private func getQuestions() async {
        do {
            // format the category search string
            var catSearchString = ""
            for cat in categories {
                if cat.active {
                    if catSearchString.isEmpty {
                        catSearchString = cat.searchName
                    } else {
                        catSearchString = "\(catSearchString),\(cat.searchName)"
                    }
                }
            }
        
            // format the level search string
            var lvlSearchString = ""
            for lvl in levels {
                if lvl.active {
                    if lvlSearchString.isEmpty {
                        lvlSearchString = lvl.searchName
                    } else {
                        lvlSearchString = "\(lvlSearchString),\(lvl.searchName)"
                    }
                }
            }
            
            // get the questions
            let questions = try await QuestionRepository.fetchQuestions(categories: catSearchString, difficulties: lvlSearchString)
            self.questions = questions
            status = .Success
        } catch {
            print("Error \(error)")
            status = .Failure
        }
    }

    // MARK: - Main Audio Player

    var mAudioPlayer: AVAudioPlayer!
    
    func mPlayAudio() {
        let sound = Bundle.main.path(forResource: "trivia1", ofType: "mp3", inDirectory: "Sounds")
        mAudioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        mAudioPlayer.numberOfLoops = -1
        if (bMusicOn) {
            mAudioPlayer.volume = 1
        } else {
            mAudioPlayer.volume = 0
        }
        mAudioPlayer.play()
    }
        
    func mStopMusic() {
        if (mAudioPlayer != nil) {
            mAudioPlayer.setVolume( 0, fadeDuration: 1)
        }
    }
    
    func mStartMusic() {
        if (mAudioPlayer != nil) {
            if (bMusicOn) {
                mAudioPlayer.setVolume( 1, fadeDuration: 1)
            }
        }
    }
    // MARK: - Game Play Audio Player
    
    var gMusicPlayer: AVAudioPlayer!
    
    func gPlayMusic() {
        let songs = ["trivia2","trivia3","trivia4","trivia5"]
        let i = Int.random(in: 0...3)
        let sound = Bundle.main.path(forResource: songs[i], ofType: "mp3", inDirectory: "Sounds")
        gMusicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        gMusicPlayer.numberOfLoops = -1
        if (bMusicOn) {
            gMusicPlayer.volume = 0.1
        } else {
            gMusicPlayer.volume = 0
        }
        gMusicPlayer.play()
    }
    
    func gStopMusic() {
        if (gMusicPlayer != nil) {
            gMusicPlayer.setVolume( 0, fadeDuration: 1)
        }
    }
    
    func gStartMusic() {
        if (gMusicPlayer != nil) {
            if (bMusicOn) {
                gMusicPlayer.setVolume( 0.1, fadeDuration: 1)
            }
        }
    }
    
    // MARK: - Init

    init() {

        categories = CategoryHelper().get()
        levels = LevelHelper().get()
        highestScores = ScoreHelper().getScores()
        if UserDefaults.standard.bool(forKey: "K.USER_DEFAULTS_SETTINGS_SET") == true {
            bSoundOn = UserDefaults.standard.bool(forKey: "K.SOUND_ON")
            bMusicOn =  UserDefaults.standard.bool(forKey: "K.MUSIC_ON")
        }
        
    }
    
}

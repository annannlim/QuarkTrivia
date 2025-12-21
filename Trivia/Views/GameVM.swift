//
//  StaticData.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import SwiftUI
import UIKit

enum Status {
    case NotStarted
    case Fetching
    case Success
    case Failure
}

@MainActor
final class GameVM: ObservableObject {
  
    private let repo : QuestionRepository
    
    // MARK: - Categories, Levels, Sound and Scores processing

    @AppStorage(K.USER_DEFAULTS_SETTINGS_SET) var settingsSet : Bool?
    @AppStorage(K.SOUND_ON) var soundOn : Bool = true
    @AppStorage(K.MUSIC_ON) var musicOn : Bool = true
    
    //@Published var settingsSet: Bool = false
    @Published var categories: [Category] = []
    @Published var levels: [Level] = []
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var highestScores = [0,0,0]
    @Published var bSoundOn = true
    @Published var bMusicOn = true

    func saveSettings() {
        //UserDefaults.standard.set(true, forKey: K.USER_DEFAULTS_SETTINGS_SET)
        CategoryHelper().save(categories: categories)
        LevelHelper().save(levels: levels)
        soundOn = bSoundOn
        musicOn = bMusicOn
        settingsSet = true
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
        
    @Published var status: Status = .NotStarted
    @Published var questions : [Question] = []
    @Published var idx : Int = 0
    
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
            let questions = try await repo.fetchQuestions(categories: catSearchString, difficulties: lvlSearchString)
            self.questions = questions
            status = .Success
        } catch {
            print("Error \(error)")
            status = .Failure
        }
    }

    
    // MARK: - Init and clean-up

    private var observers = [NSObjectProtocol]()

    init(repo: QuestionRepository) {

        self.repo = repo
        //settingsSet = UserDefaults.standard.bool(forKey: K.USER_DEFAULTS_SETTINGS_SET)
        categories = CategoryHelper().get()
        levels = LevelHelper().get()
        highestScores = ScoreHelper().getScores()
        bSoundOn = soundOn
        bMusicOn = musicOn
        
//        observers.append(
//            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
//                // how to detect app started
//            }
//        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                // how to detect app stopped
                Task {
                    await self.endGame()
                }
            }
        )
    }
    
    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}

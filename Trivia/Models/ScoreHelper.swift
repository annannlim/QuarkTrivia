//
//  ScoreHelper.swift
//  Trivia
//
//  Created by Annabel Lim on 3/9/24.
//

import Foundation

struct ScoreHelper {
    
    func getScores() -> [Int] {
        let savePath = FileManager.documentsDirectory.appending(path: "SavedScores")
        var scores = [Int]()
        do {
            let data = try Data(contentsOf: savePath)
            scores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            scores = [0,0,0]
        }
        return scores
    }

    func saveScores(scores: [Int]) {
        let savePath = FileManager.documentsDirectory.appending(path: "SavedScores")
        do {
            let data = try JSONEncoder().encode(scores)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
}


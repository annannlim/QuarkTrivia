//
//  DifficultyHelper.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import Foundation

struct LevelHelper {

    func get() -> [Level] {
        let statuses = getLevelStatuses()
        return [
            Level(id: 1, name: "Easy", searchName: "easy", active: statuses[0]),
            Level(id: 2, name: "Moderate", searchName: "medium",active: statuses[1]),
            Level(id: 3, name: "Difficult", searchName: "hard",active: statuses[2])
        ]
    }
    
    private func getLevelStatuses() ->  [Bool] {
        let savePath = FileManager.documentsDirectory.appending(path: "SavedLevelStatuses")
        var levels = [Bool]()
        do {
            let data = try Data(contentsOf: savePath)
            levels = try JSONDecoder().decode([Bool].self, from: data)
        } catch {
            levels = [true,true,true]
        }
        return levels
    }
    
    func save(levels: [Level]) {
        saveLevelStatuses(levelStatuses:  levels.map { $0.active })
    }
    
    private func saveLevelStatuses(levelStatuses: [Bool]) {
        let savePath = FileManager.documentsDirectory.appending(path: "SavedLevelStatuses")
        do {
            let data = try JSONEncoder().encode(levelStatuses)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
}

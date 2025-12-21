//
//  QuestionCategories.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import Foundation

struct CategoryHelper {
    
    func get() -> [Category] {
        let statuses = getCategoryStatuses()
        return [
            Category(id: 1, name: "Arts and Literature", searchName: "arts_and_literature", active: statuses[0]),
            Category(id: 2, name: "Film and TV", searchName: "film_and_tv",active: statuses[1]),
            Category(id: 3, name: "Food and Drink", searchName: "food_and_drink",active: statuses[2]),
            Category(id: 4, name: "General Knowledge", searchName: "general_knowledge",active: statuses[3]),
            Category(id: 5, name: "Geography", searchName: "geography",active: statuses[4]),
            Category(id: 6, name: "History", searchName: "history",active: statuses[5]),
            Category(id: 7, name: "Music", searchName: "music",active: statuses[6]),
            Category(id: 8, name: "Science", searchName: "science",active: statuses[7]),
            Category(id: 9, name: "Society and Culture", searchName: "society_and_culture",active: statuses[8]),
            Category(id: 10, name: "Sports and Leisure", searchName: "sport_and_leisure",active: statuses[9])
        ]
    }
    
    private func getCategoryStatuses() ->  [Bool] {
        let savePath = FileManager.documentsDirectory.appending(path: "SavedCategoryStatuses")
        var categories = [Bool]()
        do {
            let data = try Data(contentsOf: savePath)
            categories = try JSONDecoder().decode([Bool].self, from: data)
        } catch {
            categories = [true,true,true,true,true,true,true,true,true,true]
        }
        return categories
    }
    
    func save(categories: [Category]) {
        saveCategoryStatuses(categoryStatuses:  categories.map { $0.active })
    }
    
    private func saveCategoryStatuses(categoryStatuses: [Bool]) {
        let savePath = FileManager.documentsDirectory.appending(path: "SavedCategoryStatuses")
        do {
            let data = try JSONEncoder().encode(categoryStatuses)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
}

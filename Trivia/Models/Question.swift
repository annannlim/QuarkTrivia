//
//  Question.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import Foundation

struct Question: Codable, Identifiable {

    let id: String
    let category: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    var allAnswers : [String] = []
    
    enum QuestionKeys: String, CodingKey {
        case id
        case category
        case difficulty
        case question
        case correctAnswer
        case incorrectAnswers
        enum QuestionTextKeys: String, CodingKey {
            case text
        }
    }
        
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: QuestionKeys.self)
        id = try container.decode(String.self, forKey: .id)
        category = try container.decode(String.self, forKey: .category)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        let questionTextContainer = try container.nestedContainer(keyedBy: QuestionKeys.QuestionTextKeys.self, forKey: .question)
        question = try questionTextContainer.decode(String.self, forKey: .text)

        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        let incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)

        allAnswers.append(correctAnswer)
        allAnswers.append(contentsOf: incorrectAnswers)
        allAnswers.shuffle()
    }
 
    // Create example for previews
    init() {
        id = "1"
        category = "History"
        difficulty = "Easy"
        question = "Who is afraid of the big bad wolf?"
        correctAnswer = "Happy"
        allAnswers = ["Sleepy","Bashful", "Grumpy", "Sneezy"]
    }
    
    /*
    [
      {
        "category": "music",
        "id": "5f9f1b9b0e1b9c0017a5f1a5",
        "tags": [
          "france",
          "geography",
          "capital_cities",
          "cities"
        ],
        "difficulty": "easy",
        "regions": [
          "string"
        ],
        "isNiche": true,
        "question": {
          "text": "What is the capital of France?"
        },
        "correctAnswer": "Paris",
        "incorrectAnswers": [
          "London",
          "Berlin",
          "Brussels"
        ],
        "type": "text_choice"
      }
    ]
    */
    
}

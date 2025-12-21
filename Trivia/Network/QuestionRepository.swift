//
//  Network.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import Foundation


struct QuestionRepository {
    
    enum QuestionRepoError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://the-trivia-api.com")!

    // Use "URLSession" to make calls
    // Use "try await" and "async throws" to manage background processing and error handling
    func fetchQuestions(categories: String, difficulties: String) async throws -> [Question] {

        /*
          https://the-trivia-api.com/v2/questions?limit=50&type=text_choice&categories=history,film_and_tv&difficulties=medium
         difficulty = "easy" "medium" "hard"
         category = "music" "sport_and_leisure" "film_and_tv" "arts_and_literature" "history"
         "society_and_culture" "science" "geography" "food_and_drink" "general_knowledge"
         limit = 20
         */

        let qUrl = baseURL.appending(path: "v2/questions")
        var qComponents = URLComponents(url: qUrl, resolvingAgainstBaseURL: true)
        let queryItem1 = URLQueryItem(name: "types", value: "text_choice")
        let queryItem2 = URLQueryItem(name: "limit", value: String(K.QUESTIONS_PER_GAME))
        let queryItem3 = URLQueryItem(name: "categories", value: categories)
        let queryItem4 = URLQueryItem(name: "difficulties", value: difficulties)
        qComponents?.queryItems = [queryItem1, queryItem2, queryItem3, queryItem4]

        // confirm our URL is valid, if not throw badURL error
        guard let fetchURL = qComponents?.url else {
            throw QuestionRepoError.badURL
        }
        
        // fetch the data using the URL
        let (data, response) = try await URLSession.shared.data(from: fetchURL)

        // confirm we got response, if not throw badResponse error
        guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 299 else {
            throw QuestionRepoError.badResponse
        }
        
        // confirm we got data parsed correctly, if not throw badData error
        guard let questions = try? JSONDecoder().decode([Question].self, from: data) else {
            throw QuestionRepoError.badData
        }
        
        return questions
    }
    
    
}

//
//  Category.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import Foundation

struct Category : Codable, Identifiable {
    let id: Int
    let name: String
    let searchName: String
    var active: Bool
}


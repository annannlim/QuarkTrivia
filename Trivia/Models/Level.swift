//
//  StaticData.swift
//  Trivia
//
//  Created by Annabel Lim on 3/6/24.
//

import Foundation

struct Level : Codable, Identifiable {
    let id: Int
    let name: String
    let searchName: String
    var active: Bool
}

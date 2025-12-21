//
//  FileManager.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}



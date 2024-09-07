//
//  Character.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail

    struct Thumbnail: Codable {
        let path: String
        let `extension`: String
    }
}

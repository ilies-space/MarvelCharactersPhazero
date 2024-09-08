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
    let comics: Comics
    let urls: [URLInfo]

    struct Thumbnail: Codable {
        let path: String?
        let `extension`: String?
    }

    struct Comics: Codable {
        let items: [Comic]
    }

    struct Comic: Codable {
        let name: String
        let resourceURI: String?
        let thumbnail: Thumbnail?
    }

    struct URLInfo: Codable {
        let type: String
        let url: String
    }
}

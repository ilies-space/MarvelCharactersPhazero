//
//  ApiResponseModel.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 8/9/2024.
//

struct MarvelDataWrapper: Codable {
    let code: Int?
    let status: String?
    let data: MarvelCharacterDataContainer?
}

struct MarvelCharacterDataContainer: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Character]?
}

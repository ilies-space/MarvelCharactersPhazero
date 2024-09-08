//
//  MarvelAPIService.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import Foundation
import CryptoKit

class MarvelAPIService {
    static let shared = MarvelAPIService()
    
    // API keys
    private let publicKey = "a427215652ac7b01730e27689629133b"
    private let privateKey = "522d5aba40d008e1c916f0a2767925011bdb7e0c"
    private let baseURL = "https://gateway.marvel.com/v1/public/characters"
    
    // Timestamp for hash generation
    private let timestamp = "\(Int(Date().timeIntervalSince1970))"
    
    // Hash for Marvel API authentication (md5 of timestamp + privateKey + publicKey)
    private var hash: String {
        let toHash = timestamp + privateKey + publicKey
        return Insecure.MD5.hash(data: toHash.data(using: .utf8)!)
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
    
    func fetchCharacters(offset: Int, limit: Int = 10, completion: @escaping ([Character]?) -> Void) {
        print("Calling fetchCharacters with offset: \(offset)")
        
        // Construct the full URL with the necessary parameters
        let urlString = "\(baseURL)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&offset=\(offset)&limit=\(limit)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // Perform the API call
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching characters: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }
            
            do {
                // Parse the JSON response into MarvelDataWrapper
                let decoder = JSONDecoder()
                let response = try decoder.decode(MarvelDataWrapper.self, from: data)
                let characters = response.data?.results
                print("Fetched \(characters?.count ?? 0) characters")
                completion(characters)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}


// MARK: - Models for API Response

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


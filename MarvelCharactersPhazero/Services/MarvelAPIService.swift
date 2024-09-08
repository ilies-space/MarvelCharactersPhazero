//  MarvelAPIService.swift
//  MarvelCharactersPhazero
//
//  Created by Ilies Ould menouer on 6/9/2024.

import Foundation
import CryptoKit

protocol APIService {
    func fetchCharacters(offset: Int, limit: Int, completion: @escaping (Result<[Character], Error>) -> Void)
}

class MarvelAPIService: APIService {
    static let shared = MarvelAPIService()
    
    private let baseURL = "https://gateway.marvel.com/v1/public/characters"
    
    private var publicKey: String? {
        return Bundle.main.infoDictionary?["MARVEL_PUBLIC_KEY"] as? String
    }
    
    private var privateKey: String? {
        return Bundle.main.infoDictionary?["MARVEL_PRIVATE_KEY"] as? String
    }
    
    private var timestamp: String {
        return "\(Int(Date().timeIntervalSince1970))"
    }
    
    private var hash: String? {
        guard let publicKey = publicKey, let privateKey = privateKey else {
            return nil
        }
        let toHash = timestamp + privateKey + publicKey
        let data = toHash.data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func fetchCharacters(offset: Int, limit: Int = 10, completion: @escaping (Result<[Character], Error>) -> Void) {
        print("Calling fetchCharacters with offset: \(offset)")
        
        // Validate API keys
        guard let publicKey = publicKey, let hash = hash else {
            completion(.failure(NetworkError.missingAPIKeys))
            return
        }
        
        // Construct URL with parameters
        let urlString = "\(baseURL)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&offset=\(offset)&limit=\(limit)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform API request
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching characters: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Decode JSON response
                let decoder = JSONDecoder()
                let response = try decoder.decode(MarvelDataWrapper.self, from: data)
                let characters = response.data?.results ?? []
                print("Fetched \(characters.count) characters")
                completion(.success(characters))
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}

// Define error types for network errors
enum NetworkError: Error {
    case invalidURL
    case noData
    case missingAPIKeys
}

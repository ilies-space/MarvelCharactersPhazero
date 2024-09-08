//
//  MarvelAPIService.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import Foundation
import CryptoKit

// Define a protocol for the API service
protocol APIService {
    func fetchCharacters(offset: Int, limit: Int, completion: @escaping (Result<[Character], Error>) -> Void)
}

class MarvelAPIService: APIService {
    static let shared = MarvelAPIService()
    
    private let baseURL = "https://gateway.marvel.com/v1/public/characters"
    
    // API keys
    // TODO: Use more secure way to store API key using Environment Variable or Keychain

    private let publicKey = "a427215652ac7b01730e27689629133b"
    private let privateKey = "522d5aba40d008e1c916f0a2767925011bdb7e0c"
    
    // Timestamp for hash generation
    private var timestamp: String {
        return "\(Int(Date().timeIntervalSince1970))"
    }
    
    // Hash for Marvel API authentication (md5 of timestamp + privateKey + publicKey)
    private var hash: String {
        let toHash = timestamp + privateKey + publicKey
        return Insecure.MD5.hash(data: toHash.data(using: .utf8)!)
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
    
    func fetchCharacters(offset: Int, limit: Int = 10, completion: @escaping (Result<[Character], Error>) -> Void) {
        print("Calling fetchCharacters with offset: \(offset)")
        
        // Construct the full URL with the necessary parameters
        let urlString = "\(baseURL)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&offset=\(offset)&limit=\(limit)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform the API call
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching characters: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Parse the JSON response into MarvelDataWrapper
                let decoder = JSONDecoder()
                let response = try decoder.decode(MarvelDataWrapper.self, from: data)
                let characters = response.data?.results ?? []
                print("Fetched \(characters.count) characters")
                completion(.success(characters))
            } catch {
                print("Error decoding data: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

// Define error types for network errors
enum NetworkError: Error {
    case invalidURL
    case noData
}

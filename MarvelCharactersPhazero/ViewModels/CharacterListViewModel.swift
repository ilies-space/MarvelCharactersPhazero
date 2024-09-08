//
//  CharacterListViewModel.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import Foundation

class CharacterListViewModel {
    var characters: [Character] = []
    var onCharactersFetched: (() -> Void)?
    private var currentOffset = 0
    private let limit = 10
    private var isFetching = false
    
    func fetchCharacters(completion: @escaping () -> Void = {}) {
        guard !isFetching else { return }
        isFetching = true
        
        MarvelAPIService.shared.fetchCharacters(offset: currentOffset, limit: limit) { [weak self] fetchedCharacters in
            guard let self = self else { return }
            
            if let fetchedCharacters = fetchedCharacters {
                self.characters.append(contentsOf: fetchedCharacters)
                self.currentOffset += self.limit
                self.onCharactersFetched?()
            } else {
                print("No characters found")
            }
            
            self.isFetching = false
            completion()
        }
    }
}

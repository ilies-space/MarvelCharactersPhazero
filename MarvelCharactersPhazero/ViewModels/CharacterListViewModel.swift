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
    var onError: ((Error) -> Void)?
    private var currentOffset = 0
    private let limit = 10
    private var isFetching = false
    
    func fetchCharacters(completion: @escaping () -> Void = {}) {
        guard !isFetching else { return }
        isFetching = true
        
        MarvelAPIService.shared.fetchCharacters(offset: currentOffset, limit: limit) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedCharacters):
                self.characters.append(contentsOf: fetchedCharacters)
                self.currentOffset += self.limit
                self.onCharactersFetched?()
                
            case .failure(let error):
                self.onError?(error)
            }
            
            self.isFetching = false
            completion()
        }
    }
}

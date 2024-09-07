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
    
    func fetchCharacters(completion: @escaping () -> Void = {}) {
        MarvelAPIService.shared.fetchCharacters { [weak self] characters in
            guard let self = self else { return }
            
            if let fetchedCharacters = characters {
                self.characters = fetchedCharacters
                self.onCharactersFetched?()
            } else {
                print("No characters found")
            }
            completion() 
        }
    }
}



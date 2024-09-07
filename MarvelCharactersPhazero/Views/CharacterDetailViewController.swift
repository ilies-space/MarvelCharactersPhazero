//
//  CharacterDetailViewController.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import Foundation

import UIKit

class CharacterDetailViewController: UIViewController {
    private let viewModel: CharacterDetailViewModel
    
    init(character: Character) {
        self.viewModel = CharacterDetailViewModel(character: character)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        print(viewModel.character)
    }
    
    private func setupUI() {
        let imageView = UIImageView()
        let nameLabel = UILabel()
        let descriptionLabel = UILabel()
        
        // Configure UI components and layout
        
        nameLabel.text = viewModel.character.name
        descriptionLabel.text = viewModel.character.description
//        if let imageURL = viewModel.character.thumbnail.url {
//            // Load image from imageURL
//        }
    }
}

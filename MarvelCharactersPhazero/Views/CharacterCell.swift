//
//  CharacterCell.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    private let characterImageView = UIImageView()
    private let characterNameLabel = UILabel()
    private let characterIdLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        characterNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        characterIdLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        characterIdLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [characterNameLabel, characterIdLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(characterImageView)
        contentView.addSubview(stackView)
        
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 60),
            characterImageView.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with character: Character) {
        characterNameLabel.text = character.name
        characterIdLabel.text = "ID: \(character.id)"
//        if let url = URL(string: "\(character.thumbnail.path).\(character.thumbnail.extension)") {
//            // Load the image asynchronously
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        self.characterImageView.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
//        }
    }
}

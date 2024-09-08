//
//  CharacterCell.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    private let characterImageView = UIImageView()
    private let characterNameLabel = UILabel()
    private let wikiButton = UIButton(type: .system)
    
    var onWikiButtonTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wikiButton.translatesAutoresizingMaskIntoConstraints = false

        characterImageView.contentMode = .scaleAspectFill
        characterImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = 8
        
        characterNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        characterNameLabel.textAlignment = .center
        characterNameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        characterNameLabel.textColor = .white
        characterNameLabel.layer.cornerRadius = 4
        characterNameLabel.clipsToBounds = true
        
        wikiButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        wikiButton.tintColor = .white
        wikiButton.addTarget(self, action: #selector(wikiButtonTapped), for: .touchUpInside)
        
        // Adding background color and shadow to the wikiButton
        wikiButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        wikiButton.layer.cornerRadius = 12
        wikiButton.layer.shadowColor = UIColor.black.cgColor
        wikiButton.layer.shadowOpacity = 0.5
        wikiButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        wikiButton.layer.shadowRadius = 4
        wikiButton.layer.masksToBounds = false
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

        contentView.addSubview(characterImageView)
        contentView.addSubview(characterNameLabel)
        contentView.addSubview(wikiButton)

        NSLayoutConstraint.activate([
            // Full size image view
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5), // Aspect ratio 2:3
            
            // Name label at the bottom of the image view
            characterNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 24),

            // Info button at the top-right corner of the image view
            wikiButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wikiButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            wikiButton.widthAnchor.constraint(equalToConstant: 36),
            wikiButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @objc private func wikiButtonTapped() {
        onWikiButtonTap?()
    }
    
    func configure(with character: Character) {
        characterNameLabel.text = "\(character.name) (ID: \(character.id))"

        if let path = character.thumbnail.path, let ext = character.thumbnail.extension {
            let urlString = "\(path).\(ext)"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.characterImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        if let wikiURL = character.urls.first(where: { $0.type == "wiki" })?.url {
            wikiButton.isHidden = false
            onWikiButtonTap = { UIApplication.shared.open(URL(string: wikiURL)!) }
        } else {
            wikiButton.isHidden = true
        }
    }
}

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
    private let wikiButton = UIButton(type: .system)

    var onWikiButtonTap: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        characterIdLabel.translatesAutoresizingMaskIntoConstraints = false
        wikiButton.translatesAutoresizingMaskIntoConstraints = false

        wikiButton.setTitle("Open Wiki", for: .normal)
        wikiButton.addTarget(self, action: #selector(wikiButtonTapped), for: .touchUpInside)

        contentView.addSubview(characterImageView)
        contentView.addSubview(characterNameLabel)
        contentView.addSubview(characterIdLabel)
        contentView.addSubview(wikiButton)

        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 60),
            characterImageView.heightAnchor.constraint(equalToConstant: 60),
            
            characterNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            characterNameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 12),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            characterIdLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 4),
            characterIdLabel.leadingAnchor.constraint(equalTo: characterNameLabel.leadingAnchor),
            characterIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            wikiButton.topAnchor.constraint(equalTo: characterIdLabel.bottomAnchor, constant: 4),
            wikiButton.leadingAnchor.constraint(equalTo: characterNameLabel.leadingAnchor),
            wikiButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            wikiButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }


    @objc private func wikiButtonTapped() {
        onWikiButtonTap?()
    }

    func configure(with character: Character) {
        characterNameLabel.text = character.name
        characterIdLabel.text = "ID: \(character.id)"
        
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

//
//  CharacterDetailViewController.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//
import UIKit

class CharacterDetailViewController: UIViewController {
    private let viewModel: CharacterDetailViewModel
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let placeholderImage = UIImage(named: "placeholder") 
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
        updateUI()
    }
    
    private func setupUI() {
        // Configure UI components and layout
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.numberOfLines = 0
        
        // Add views and set constraints
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func updateUI() {
        nameLabel.text = viewModel.character.name
        descriptionLabel.text = viewModel.character.description
        
        if let imageURL = URL(string: "\(viewModel.character.thumbnail.path).\(viewModel.character.thumbnail.extension)") {
            // Load image from imageURL
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data) ?? self.placeholderImage
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = self.placeholderImage
                    }
                }
            }.resume()
        } else {
            imageView.image = placeholderImage
        }
    }
}

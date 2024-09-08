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
    private let comicsCollectionView: UICollectionView
    private let titleLabel = UILabel()

    init(character: Character) {
        self.viewModel = CharacterDetailViewModel(character: character)
        
        // Set up collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        // Calculate item size based on view frame and available space
        let collectionViewHeight: CGFloat = 200 // Set a fixed height for the collection view

        
        comicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        let availableHeight = collectionViewHeight - layout.sectionInset.top - layout.sectionInset.bottom
        layout.itemSize = CGSize(width: view.frame.width * 0.4, height: availableHeight)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        bindData()
    }


    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        comicsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        comicsCollectionView.dataSource = self
        comicsCollectionView.delegate = self
        comicsCollectionView.backgroundColor = .clear
        comicsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ComicCell")
        
        // Configure the imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        // Configure the nameLabel
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        nameLabel.layer.cornerRadius = 8
        nameLabel.clipsToBounds = true

        // Configure the titleLabel
        titleLabel.text = "Comics List"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        titleLabel.layer.cornerRadius = 8
        titleLabel.clipsToBounds = true

        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(titleLabel)
        view.addSubview(comicsCollectionView)

        NSLayoutConstraint.activate([
            // Full width image view
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0), // Aspect ratio 1:1
            
            // Name label below the image
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Title label above the collection view
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Horizontally scrolling comics collection view
            comicsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            comicsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            comicsCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }


    private func bindData() {
        // Set character image and name
        nameLabel.text = viewModel.character.name

        if let path = viewModel.character.thumbnail.path, let ext = viewModel.character.thumbnail.extension {
            let urlString = "\(path).\(ext)"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }

        // Reload collection view to display comics
        comicsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource and Delegate
extension CharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.character.comics.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath)
        
        // Remove any existing subviews to prevent stacking when cells are reused
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Configure cell appearance
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.red.cgColor
        cell.contentView.clipsToBounds = true
        
        let comic = viewModel.character.comics.items[indexPath.row]
        
        // Create the comic image view
        let comicImageView = UIImageView(frame: cell.contentView.bounds)
        comicImageView.contentMode = .scaleAspectFill
        comicImageView.clipsToBounds = true
        
        // Set placeholder image
        comicImageView.image = UIImage(named: "comic-placeholder")
        
        // Load the comic image
        if let path = comic.thumbnail?.path, let ext = comic.thumbnail?.extension {
            let urlString = "\(path).\(ext)"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            comicImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        // Create the comic title label
        let comicLabel = UILabel(frame: CGRect(x: 0, y: cell.contentView.bounds.height - 40, width: cell.contentView.bounds.width, height: 40))
        comicLabel.text = comic.name
        comicLabel.font = UIFont.boldSystemFont(ofSize: 16)
        comicLabel.textAlignment = .center
        comicLabel.textColor = .white
        comicLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        comicLabel.clipsToBounds = true

        // Add image and label to the content view
        cell.contentView.addSubview(comicImageView)
        cell.contentView.addSubview(comicLabel)
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comic = viewModel.character.comics.items[indexPath.row]
        if let comicURL = comic.resourceURI, let url = URL(string: comicURL) {
            UIApplication.shared.open(url)
        }
    }
}

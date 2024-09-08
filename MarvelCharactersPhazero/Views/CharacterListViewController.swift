//  CharacterListViewController.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import UIKit

class CharacterListViewController: UIViewController {
    private let viewModel = CharacterListViewModel()
    private let collectionView: UICollectionView
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingLabel = UILabel()
    private let loadingMoreView = UIActivityIndicatorView(style: .large)

    private var isFetchingMore = false
    private let threshold = 5 // Number of items from the bottom to trigger fetching more

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let itemWidth = (UIScreen.main.bounds.width - 48) / 2 // 16 + 16 padding
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5) // Aspect ratio 2:3

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLogoImageView()
        setupTitleLabel()
        setupCollectionView()
        setupActivityIndicator()
        setupLoadingMoreView()
        setupViewModel()
        fetchData()
    }

    private func setupLogoImageView() {
        let logoImageView = UIImageView(image: UIImage(named: "marvel_logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "Marvel Characters"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spacer)

        NSLayoutConstraint.activate([
            spacer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Setup the loading label
        loadingLabel.text = "Loading Characters..."
        loadingLabel.textColor = .white
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8)
        ])
    }

    private func setupLoadingMoreView() {
        loadingMoreView.translatesAutoresizingMaskIntoConstraints = false
        loadingMoreView.color = .white
        loadingMoreView.hidesWhenStopped = true
        view.addSubview(loadingMoreView)
        
        NSLayoutConstraint.activate([
            loadingMoreView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingMoreView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onCharactersFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.loadingLabel.isHidden = true
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.loadingLabel.isHidden = true
                self?.showErrorAlert(error: error)
            }
        }
    }

    private func fetchData() {
        activityIndicator.startAnimating()
        loadingLabel.isHidden = false
        viewModel.fetchCharacters { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.loadingLabel.isHidden = true
                self?.collectionView.reloadData()
            }
        }
    }

    private func fetchMoreData() {
        guard !isFetchingMore else { return }
        isFetchingMore = true
        loadingMoreView.startAnimating()
        viewModel.fetchCharacters { [weak self] in
            DispatchQueue.main.async {
                self?.loadingMoreView.stopAnimating()
                self?.isFetchingMore = false
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func showErrorAlert(error: Error) {
        let errorMessage: String
        if let networkError = error as? NetworkError {
            switch networkError {
            case .missingAPIKeys:
                errorMessage = "API keys are missing. Please check your configuration."
            case .invalidURL:
                errorMessage = "The URL is invalid."
            case .noData:
                errorMessage = "No data returned from the server."
            }
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }

        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension CharacterListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }

        let character = viewModel.characters[indexPath.item]
        cell.configure(with: character)

        cell.onWikiButtonTap = {
            if let wikiURL = character.urls.first(where: { $0.type == "wiki" })?.url {
                if let url = URL(string: wikiURL) {
                    UIApplication.shared.open(url)
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.item]
        let detailVC = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollPosition = scrollView.contentOffset.y + scrollView.frame.size.height

        if scrollPosition > contentHeight - CGFloat(threshold), !isFetchingMore {
            fetchMoreData()
        }
    }
}

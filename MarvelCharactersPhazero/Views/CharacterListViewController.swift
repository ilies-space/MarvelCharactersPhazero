//
//  CharacterListViewController.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import Foundation
import UIKit

class CharacterListViewController: UIViewController {
    private let viewModel = CharacterListViewModel()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")
        view.addSubview(tableView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    private func fetchData() {
        activityIndicator.startAnimating() // Start animating the activity indicator
        viewModel.fetchCharacters { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating() // Stop animating the activity indicator
                self?.tableView.reloadData()
            }
        }
    }
}

extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }

        let character = viewModel.characters[indexPath.row]
        cell.configure(with: character)

        // Open detail view on selection
        cell.onWikiButtonTap = {
            if let wikiURL = character.urls.first(where: { $0.type == "wiki" })?.url {
                if let url = URL(string: wikiURL) {
                    UIApplication.shared.open(url)
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        let detailVC = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

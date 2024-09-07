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
    private let comicsTableView = UITableView()

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
        bindData()
    }

    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        comicsTableView.translatesAutoresizingMaskIntoConstraints = false

        comicsTableView.dataSource = self
        comicsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ComicCell") // Register cell
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(comicsTableView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            comicsTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            comicsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindData() {
        // Debugging prints to see if data is passed correctly
        print("Binding data for character:", viewModel.character.name)

        // Set character image and name
        nameLabel.text = viewModel.character.name

        // Print character comic count for debugging
        print("Comics count:", viewModel.character.comics.items.count)

        
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

        // Reload table view to display comics
        comicsTableView.reloadData()
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CharacterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.character.comics.items.count
        print("Number of comics:", count) // Debugging print
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicCell", for: indexPath)
        let comic = viewModel.character.comics.items[indexPath.row]
        cell.textLabel?.text = comic.name
        print("Configuring cell for comic:", comic.name) // Debugging print
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comic = viewModel.character.comics.items[indexPath.row]
        if let comicURL = comic.resourceURI, let url = URL(string: comicURL) {
            print("Opening comic URL:", comicURL) // Debugging print
            UIApplication.shared.open(url)
        }
    }
}

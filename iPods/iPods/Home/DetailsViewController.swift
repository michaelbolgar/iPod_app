//
// DetailsViewController.swift
// iPods

import UIKit

final class DetailsViewController: UIViewController {

    private let podcast: PodcastFull

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let playButton = UIButton(type: .system)

    init(podcast: PodcastFull) {
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupUI()
        configure()
    }

    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 26)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.textColor = .orange
        authorLabel.textAlignment = .center

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .center

        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.backgroundColor = .orange
        playButton.tintColor = .black
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.layer.cornerRadius = 30

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 420),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            playButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 60),
            playButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func configure() {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        descriptionLabel.text = podcast.description
    }
}

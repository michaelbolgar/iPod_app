//
//  DetailsViewController.swift
//  iPods
//
//  Created by Administration  on 17/04/26.
//


import UIKit

final class DetailsViewController: UIViewController {

    // MARK: - Properties
    private let podcast: PodcastFull

    init(podcast: PodcastFull) {
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 28
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let blackContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let metaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        loadImage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradient()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black

        let likeButton = makeCircleButton(systemName: "heart")
        let downloadButton = makeCircleButton(systemName: "arrow.down")
        let shareButton = makeCircleButton(systemName: "square.and.arrow.up")

        let buttonStack = UIStackView(arrangedSubviews: [
            likeButton,
            downloadButton,
            shareButton
        ])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 24
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(coverImageView)
        contentView.addSubview(backButton)
        contentView.addSubview(blackContainer)
        blackContainer.addSubview(titleLabel)
                blackContainer.addSubview(authorLabel)
                blackContainer.addSubview(metaLabel)
                blackContainer.addSubview(descriptionLabel)
                blackContainer.addSubview(buttonStack)

                scrollView.translatesAutoresizingMaskIntoConstraints = false
                contentView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([

                    scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

                    coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    coverImageView.heightAnchor.constraint(equalToConstant: 470),

                    backButton.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: 20),
                    backButton.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: 20),

                    blackContainer.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -65),
                    blackContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    blackContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    blackContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: blackContainer.topAnchor, constant: 42),
                    titleLabel.leadingAnchor.constraint(equalTo: blackContainer.leadingAnchor, constant: 24),
                    titleLabel.trailingAnchor.constraint(equalTo: blackContainer.trailingAnchor, constant: -24),

                    authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                    authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

                    metaLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 14),
                    metaLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    metaLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

                    descriptionLabel.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 18),
                    descriptionLabel.leadingAnchor.constraint(equalTo: blackContainer.leadingAnchor, constant: 32),
                    descriptionLabel.trailingAnchor.constraint(equalTo: blackContainer.trailingAnchor, constant: -32),

                    buttonStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
                    buttonStack.centerXAnchor.constraint(equalTo: blackContainer.centerXAnchor),
                    buttonStack.bottomAnchor.constraint(equalTo: blackContainer.bottomAnchor, constant: -32)
                ])
            }

            private func configure() {
                titleLabel.text = podcast.title
                authorLabel.text = podcast.author
                descriptionLabel.text = podcast.description
                metaLabel.text = "⭐️ \(podcast.rating)   \(podcast.episodeCount) eps   \(podcast.genre)"
            }

            private func loadImage() {
                guard let url = podcast.artworkURL else { return }

                URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                    guard let self,
                          let data = data,
                          let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                                    self.coverImageView.image = image
                                }
                            }.resume()
                        }

                        private func addGradient() {
                            coverImageView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

                            let gradient = CAGradientLayer()
                            gradient.colors = [
                                UIColor.clear.cgColor,
                                UIColor.black.cgColor
                            ]
                            gradient.locations = [0.55, 1.0]
                            gradient.frame = coverImageView.bounds

                            coverImageView.layer.addSublayer(gradient)
                        }

                        private func makeCircleButton(systemName: String) -> UIButton {
                            let button = UIButton(type: .system)
                            button.setImage(UIImage(systemName: systemName), for: .normal)
                            button.tintColor = .white
                            button.backgroundColor = UIColor(white: 0.12, alpha: 1)
                            button.layer.cornerRadius = 26
                            button.translatesAutoresizingMaskIntoConstraints = false

                            NSLayoutConstraint.activate([
                                button.widthAnchor.constraint(equalToConstant: 52),
                                button.heightAnchor.constraint(equalToConstant: 52)
                            ])

                            return button
                        }

                        @objc private func backTapped() {
                            navigationController?.popViewController(animated: true)
                        }
                    }

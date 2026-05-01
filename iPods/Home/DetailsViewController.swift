//
//  DetailsViewController.swift
//  iPods
//
//  Created by Administration  on 28/04/26.
//



import UIKit

final class DetailsViewController: UIViewController {

    // MARK: - Data
    private let podcast: PodcastFull

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let gradientView = UIView()

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let playButton = UIButton(type: .system)

    // MARK: - Init
    init(podcast: PodcastFull) {
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DS.Color.background

        setupUI()
        configure()
    }

    // MARK: - UI Setup
    private func setupUI() {

        // Scroll
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Gradient
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0.4, 1.0]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 420)
        gradientView.layer.addSublayer(gradient)

        // Title
        titleLabel.font = DS.Font.largeTitle
        titleLabel.textColor = DS.Color.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        // Author
        authorLabel.font = DS.Font.body
        authorLabel.textColor = DS.Color.accent
        authorLabel.textAlignment = .center

        // Description
        descriptionLabel.font = DS.Font.subBody
        descriptionLabel.textColor = DS.Color.textSecondary
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 4

        // Play button
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .black
        playButton.backgroundColor = DS.Color.accent
        playButton.layer.cornerRadius = 30

        // Add views
        contentView.addSubview(imageView)
        imageView.addSubview(gradientView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(playButton)

        // Layout
        NSLayoutConstraint.activate([

            // Scroll
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Image
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 420),

            // Gradient
            gradientView.topAnchor.constraint(equalTo: imageView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            // Title
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: DS.Spacing.l),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),

            // Author
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DS.Spacing.xs),
            authorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Description
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: DS.Spacing.s),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),

            // Play
            playButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: DS.Spacing.xl),
            playButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 60),
            playButton.heightAnchor.constraint(equalToConstant: 60),

            playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xl)
        ])
    }

    // MARK: - Configure
    private func configure() {

        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        descriptionLabel.text = podcast.description

        if let url = podcast.artworkURL {
            Task {
                if let data = try? await URLSession.shared.data(from: url).0,
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        self.imageView.image = image
                    }
                }
            }
        } else {
            imageView.backgroundColor = .darkGray
        }
    }
}

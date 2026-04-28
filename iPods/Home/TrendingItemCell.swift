//
//  TrendingItemCell.swift
//  iPods
//
//  Created by Administration  on 28/04/26.
//


// TrendingItemCell.swift
// iPods

import UIKit

final class TrendingItemCell: UICollectionViewCell {

    static let reuseID = "TrendingItemCell"

    // MARK: - UI

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.15, alpha: 1)
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.numberOfLines = 2
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = .systemFont(ofSize: 12)
        l.numberOfLines = 1
        return l
    }()

    // MARK: - Image task

    private var imageTask: Task<Void, Never>?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        imageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.backgroundColor = .clear

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, authorLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    // MARK: - Configure

    func configure(with podcast: PodcastFull) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        loadImage(url: podcast.artworkURL)
    }

    // MARK: - Image loading с кэшем

    private func loadImage(url: URL?) {
        guard let url else { return }

        // Проверяем кэш
        if let cached = ImageCache.shared.image(for: url.absoluteString) {
            imageView.image = cached
            return
        }

        imageTask = Task { [weak self] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }
                guard let image = UIImage(data: data) else { return }
                ImageCache.shared.setImage(image, for: url.absoluteString)
                await MainActor.run {
                    self?.imageView.image = image
                }
            } catch {
                // картинка не загрузилась — остаётся серый placeholder
            }
        }
    }
}

// MARK: - Image Cache

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() { cache.countLimit = 100 }

    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

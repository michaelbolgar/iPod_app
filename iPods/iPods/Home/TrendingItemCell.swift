//
//  TrendingItemCell.swift
//  iPods
//
//  Created by Administration  on 18/04/26.
//
import UIKit
import DesignSys
final class TrendingItemCell: UICollectionViewCell {

    static let reuseID = "TrendingItemCell"

    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private var imageTask: URLSessionDataTask?
    private var currentImageURL: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        contentView.backgroundColor = .clear

        coverImageView.backgroundColor = UIColor(white: 0.15, alpha: 1)
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .white
        titleLabel.font = AppFonts.secondaryMedium(size: 14)
        titleLabel.numberOfLines = 2

        authorLabel.textColor = .lightGray
        authorLabel.font = AppFonts.secondary(size: 12)

        let stack = UIStackView(arrangedSubviews: [
            coverImageView,
            titleLabel,
            authorLabel
        ])

        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        currentImageURL = nil
        coverImageView.image = nil
    }

    func configure(with podcast: PodcastFull) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author

        guard let url = podcast.artworkURL else { return }
        currentImageURL = url
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        imageTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            guard self.currentImageURL == url else { return }
            DispatchQueue.main.async { self.coverImageView.image = image }
        }
        imageTask?.resume()
    }
}

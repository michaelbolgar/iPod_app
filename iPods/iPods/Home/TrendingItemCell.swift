//
//  TrendingItemCell.swift
//  iPods
//
//  Created by Administration  on 18/04/26.
//
import UIKit
final class TrendingItemCell: UICollectionViewCell {

    static let reuseID = "TrendingItemCell"

    private let imageView = UIView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        contentView.backgroundColor = .clear

        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1)
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 2

        authorLabel.textColor = .lightGray
        authorLabel.font = .systemFont(ofSize: 12)

        let stack = UIStackView(arrangedSubviews: [
            imageView,
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

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    func configure(with podcast: PodcastFull) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
    }
}

import UIKit

final class TrendingItemCell: UICollectionViewCell {

    static let reuseID = "TrendingItemCell"

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        contentView.backgroundColor = UIColor(white: 0.08, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.numberOfLines = 2

        authorLabel.textColor = .lightGray
        authorLabel.font = .systemFont(ofSize: 12)

        let stack = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel,
            authorLabel
        ])

        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    func configure(with podcast: PodcastFull) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
    }
}


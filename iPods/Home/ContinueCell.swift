// ContinueCell.swift
// iPods

import UIKit

final class ContinueCell: UITableViewCell {

    static let reuseID = "ContinueCell"

    private enum Layout {
        static let coverSize: CGFloat = 56
        static let coverCornerRadius: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let innerSpacing: CGFloat = 12
    }

    // MARK: - UI

    private let coverView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.layer.cornerRadius = Layout.coverCornerRadius
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = .systemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        bar.trackTintColor = UIColor.white.withAlphaComponent(0.15)
        bar.progressTintColor = UIColor(red: 1, green: 0.6, blue: 0.1, alpha: 1)
        bar.layer.cornerRadius = 2
        bar.clipsToBounds = true
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        coverView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        progressBar.progress = 0
    }

    // MARK: - Layout

    private func setupLayout() {
        [coverView, titleLabel, authorLabel, progressBar].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalPadding),
            coverView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverView.widthAnchor.constraint(equalToConstant: Layout.coverSize),
            coverView.heightAnchor.constraint(equalToConstant: Layout.coverSize),

            titleLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: Layout.innerSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalPadding),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            progressBar.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    // MARK: - Configure

    //func configure(with podcast: PodcastFull) {
      //  titleLabel.text = podcast.title
       // authorLabel.text = podcast.author
       // progressBar.progress = podcast.progress
    }
//}

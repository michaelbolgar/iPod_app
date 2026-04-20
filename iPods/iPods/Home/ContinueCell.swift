//
//  ContinueCell.swift
//  iPods
//
//  Created by Administration  on 16/04/26.
//

import UIKit

final class ContinueCell: UITableViewCell {

    static let reuseID = "ContinueCell"

    // MARK: - Constants

    private enum Layout {
        static let coverSize: CGFloat = 56
        static let coverCornerRadius: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let innerSpacing: CGFloat = 12
    }

    // MARK: - UI

    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = Layout.coverCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        bar.trackTintColor = UIColor.white.withAlphaComponent(0.15)
        bar.progressTintColor = UIColor(red: 1, green: 0.6, blue: 0.1, alpha: 1) // orange
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

    // MARK: - Setup

    private func setupLayout() {
        [coverView, titleLabel, authorLabel, progressBar].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // Cover
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Layout.horizontalPadding),
            coverView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverView.widthAnchor.constraint(equalToConstant: Layout.coverSize),
            coverView.heightAnchor.constraint(equalToConstant: Layout.coverSize),

            // Title
            titleLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor,
                                                constant: Layout.innerSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -Layout.horizontalPadding),

            // Author
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            // Progress
            progressBar.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    // MARK: - Configure

    func configure(with podcast: Podcast) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        progressBar.progress = podcast.progress
    }
}


//
//  ContinueCell.swift
//  iPods
//
//  Created by Administration  on 16/04/26.
//



import UIKit

final class ContinueCell: UITableViewCell {

    static let reuseID = "ContinueCell"

    private let coverView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let progressBar = UIProgressView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .black
        selectionStyle = .none

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        contentView.backgroundColor = UIColor(white: 0.08, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        coverView.backgroundColor = .darkGray
        coverView.layer.cornerRadius = 12
        coverView.clipsToBounds = true
        coverView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.textColor = .lightGray
        authorLabel.font = .systemFont(ofSize: 12)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false

        progressBar.progressTintColor = .orange
        progressBar.trackTintColor = .darkGray
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(progressBar)

        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverView.widthAnchor.constraint(equalToConstant: 64),
            coverView.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            progressBar.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    func configure(with podcast: PodcastFull) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        progressBar.progress = podcast.progress
    }
}

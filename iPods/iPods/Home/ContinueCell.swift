//
//  ContinueCell.swift
//  iPods
//
//  Created by Administration  on 16/04/26.
//

import UIKit

final class ContinueCell: UITableViewCell {

    static let reuseID = "ContinueCell"

    private enum Layout {
        static let coverSize: CGFloat = 56
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 12
    }

    private let coverView: UIView = {
        let v = UIView()
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let progressBar = UIProgressView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .black
        selectionStyle = .none

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        authorLabel.textColor = .lightGray
        authorLabel.font = .systemFont(ofSize: 12)

        progressBar.progressTintColor = .orange
        progressBar.trackTintColor = UIColor.white.withAlphaComponent(0.1)

        [coverView, titleLabel, authorLabel, progressBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            coverView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverView.widthAnchor.constraint(equalToConstant: Layout.coverSize),
            coverView.heightAnchor.constraint(equalToConstant: Layout.coverSize),

            titleLabel.topAnchor.constraint(equalTo: coverView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: Layout.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            progressBar.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - FIXED CONFIG

    func configure(with model: Podcast) {
        titleLabel.text = model.title
        authorLabel.text = model.author

        // если прогресса пока нет в модели — временно 0
        progressBar.progress = 0.3
    }
}

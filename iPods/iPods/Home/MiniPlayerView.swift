//
//  MiniPlayerView.swift
//  iPods
//
//  Created by Administration  on 21/04/26.
//


import UIKit
final class MiniPlayerView: UIView {

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

    private let playButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        b.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let progressBar: UIProgressView = {
        let p = UIProgressView()
        p.progressTintColor = UIColor(red: 1, green: 0.6, blue: 0.1, alpha: 1)
        p.trackTintColor = UIColor.white.withAlphaComponent(0.15)
        p.progress = 0.4
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()

    var onPlay: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.12, alpha: 1)
        layer.cornerRadius = 14
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [titleLabel, authorLabel, playButton, progressBar].forEach {
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),

            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),

            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 2)
        ])

        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
    }

    @objc private func playTapped() {
        onPlay?()
    }

    func configure(with podcast: PodcastFull) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        progressBar.progress = podcast.progress
    }
}

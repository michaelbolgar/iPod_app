//
//  MiniPlayerView.swift
//  iPods
//
//  Created by Administration  on 18/04/26.
//


import UIKit
import DesignSys
import Networking
final class MiniPlayerView: UIView {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = AppFonts.secondaryMedium(size: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = AppFonts.secondary(size: 12)
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
        p.progressTintColor = .white
        p.trackTintColor = UIColor.white.withAlphaComponent(0.15)
        p.progress = 0
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()

    var onPlay: (() -> Void)?
    var onTap: ((PodcastFull) -> Void)?
    private var currentPodcast: PodcastFull?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.12, alpha: 1)
        layer.cornerRadius = 14
        setupLayout()
        bindPlayer()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [titleLabel, authorLabel, playButton, progressBar].forEach {
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 44),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),

            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),

            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 2)
        ])

        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
    }

    private func bindPlayer() {
        PlayerService.shared.onPlaybackStateChanged2 = { [weak self] isPlaying in
            DispatchQueue.main.async {
                let name = isPlaying ? "pause.fill" : "play.fill"
                let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
                self?.playButton.setImage(UIImage(systemName: name, withConfiguration: config), for: .normal)
            }
        }
        PlayerService.shared.onProgressChanged2 = { [weak self] current, total in
            DispatchQueue.main.async {
                self?.progressBar.progress = total > 0 ? Float(current / total) : 0
            }
        }
    }

    @objc private func playTapped() {
        onPlay?()
    }

    @objc private func viewTapped() {
        guard let podcast = currentPodcast else { return }
        onTap?(podcast)
    }

    func configure(with podcast: PodcastFull) {
        currentPodcast = podcast
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        progressBar.progress = Float(podcast.progress)
    }
}

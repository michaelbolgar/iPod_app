//
//  HomeVCMiniPlayerView 2.swift
//  iPods
//
//  Created by Nodira Shukurova on 28/04/26.
//


import UIKit
import Networking

final class HomeVClayerView: UIView {

    private let service = PlayerService.shared
    private let primaryOrange = UIColor(named: "orange") ?? .systemOrange

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Creative Mind"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progress = 0
        view.progressTintColor = .black
        view.trackTintColor = UIColor.white.withAlphaComponent(0.75)
        return view
    }()

    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        button.setImage(UIImage(systemName: "backward.fill", withConfiguration: config), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: config), for: .normal)
        button.tintColor = .black
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        bindPlayer()
        refreshUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
        bindPlayer()
        refreshUI()
    }

    private func setupUI() {
        backgroundColor = primaryOrange
        layer.cornerRadius = 10
        clipsToBounds = true

        [
            titleLabel,
            progressView,
            currentTimeLabel,
            durationLabel,
            previousButton,
            playPauseButton,
            nextButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 103),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            progressView.heightAnchor.constraint(equalToConstant: 4),

            currentTimeLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4),
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),

            durationLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4),durationLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            
            playPauseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 42),
            playPauseButton.heightAnchor.constraint(equalToConstant: 42),

            previousButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -51),
            previousButton.widthAnchor.constraint(equalToConstant: 42),
            previousButton.heightAnchor.constraint(equalToConstant: 42),

            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 51),
            nextButton.widthAnchor.constraint(equalToConstant: 42),
            nextButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }

    private func bindPlayer() {
        service.onPlaybackStateChanged = { [weak self] isPlaying in
            DispatchQueue.main.async {
                self?.updatePlayPauseIcon(isPlaying: isPlaying)
            }
        }

        service.onProgressChanged = { [weak self] current, total in
            DispatchQueue.main.async {
                self?.currentTimeLabel.text = self?.formatTime(current)
                self?.durationLabel.text = self?.formatTime(total)
                self?.progressView.progress = total > 0 ? Float(current / total) : 0
            }
        }

        service.onEpisodeChanged = { [weak self] episode in
            DispatchQueue.main.async {
                self?.titleLabel.text = episode?.title ?? "Unknown Episode"
                self?.refreshUI()
            }
        }
    }

    private func refreshUI() {
        titleLabel.text = service.currentEpisode?.title ?? "The Creative Mind"
        currentTimeLabel.text = formatTime(service.currentTime)
        durationLabel.text = formatTime(service.duration)
        progressView.progress = service.duration > 0 ? Float(service.currentTime / service.duration) : 0
        updatePlayPauseIcon(isPlaying: service.isPlaying)
    }

    private func updatePlayPauseIcon(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold)
        playPauseButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
    }

    @objc private func didTapPlayPause() {
        service.togglePlayback()
    }

    @objc private func didTapPrevious() {
        service.previous()
    }

    @objc private func didTapNext() {
        service.next()
    }

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite, !seconds.isNaN else { return "0:00" }

        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%d:%02d", minutes, seconds)
    }
}

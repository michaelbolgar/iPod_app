//
//  PlayerViewController.swift
//  iPods
//
//  Created by Nodira Shukurova on 24/04/26.
//

import UIKit
import Networking

#warning("у вас файл называется ViewController, а по факту это UIView. Надо привести к одному виду")
final class PlayerControlsView: UIView {

#warning("а в дизайн системе нет этого цвета? если нет, надо его туда перенести")
    private let primaryOrange = UIColor(named: "PrimaryOrange") ?? UIColor(
        red: 245 / 255,
        green: 158 / 255,
        blue: 12 / 255,
        alpha: 1
    )

    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = primaryOrange
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.75)
        slider.thumbTintColor = .clear
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "41:30"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        let image = UIImage(systemName: "backward.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.85)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "play.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = primaryOrange
        button.layer.cornerRadius = 33
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        let image = UIImage(systemName: "forward.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.85)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let service = PlayerService.shared

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
        backgroundColor = .clear

        #warning("это можно сократить, добавив в массив + forEach")
        addSubview(progressSlider)
        addSubview(currentTimeLabel)
        addSubview(durationLabel)
        addSubview(previousButton)
        addSubview(playPauseButton)
        addSubview(nextButton)

        NSLayoutConstraint.activate([
            progressSlider.topAnchor.constraint(equalTo: topAnchor),
            progressSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressSlider.trailingAnchor.constraint(equalTo: trailingAnchor),

            currentTimeLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 4),
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),

            durationLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 4),
            durationLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),

            playPauseButton.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 32),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 66),
            playPauseButton.heightAnchor.constraint(equalToConstant: 66),

            previousButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -17),
            previousButton.widthAnchor.constraint(equalToConstant: 56),
            previousButton.heightAnchor.constraint(equalToConstant: 56),

            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 17),
            nextButton.widthAnchor.constraint(equalToConstant: 56),
            nextButton.heightAnchor.constraint(equalToConstant: 56),

            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(didChangeSlider), for: .valueChanged)
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

                let value = total > 0 ? Float(current / total) : 0
                self?.progressSlider.value = value
            }
        }

        service.onEpisodeChanged = { [weak self] (_: Episode?) in
            DispatchQueue.main.async {
                self?.refreshUI()
            }
        }
    }

    private func refreshUI() {
        updatePlayPauseIcon(isPlaying: service.isPlaying)

        currentTimeLabel.text = formatTime(service.currentTime)
        durationLabel.text = formatTime(service.duration)

        let total = service.duration
        progressSlider.value = total > 0 ? Float(service.currentTime / total) : 0

        previousButton.alpha = service.hasPrevious || service.currentTime > 0 ? 1 : 0.45
        nextButton.alpha = service.hasNext ? 1 : 0.45
    }

    private func updatePlayPauseIcon(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        playPauseButton.setImage(image, for: .normal)
    }

    @objc private func didTapPlayPause() {
        service.togglePlayback()
    }

    @objc private func didTapPrevious() {
        service.previous()
        refreshUI()
    }

    @objc private func didTapNext() {
        service.next()
        refreshUI()
    }

    @objc private func didChangeSlider() {
        service.seek(toProgress: progressSlider.value)
    }

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite, !seconds.isNaN else { return "0:00" }

        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%d:%02d", minutes, seconds)
    }
}

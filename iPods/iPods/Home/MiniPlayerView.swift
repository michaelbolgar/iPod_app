//
//  MiniPlayerView.swift
//  iPods
//
//  Created by Administration  on 18/04/26.
//

import UIKit



final class MiniPlayerView: UIView {
    
    private let service = PlayerService.shared
    
    private var currentPodcastId: Int?
    
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
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.12, alpha: 1)
        layer.cornerRadius = 14
        setupLayout()
        setupActions()
        bindToService()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func updatePlayButton() {
        let isPlaying = service.isPlaying

        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)

        let imageName = isPlaying ? "pause.fill" : "play.fill"

        playButton.setImage(
            UIImage(systemName: imageName, withConfiguration: config),
            for: .normal
        )
    }
    
    
    private func setupLayout() {
        [titleLabel, authorLabel, playButton, progressBar].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 32),
            playButton.heightAnchor.constraint(equalToConstant: 32),
            
            
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupActions() {
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
    }
    
    
    private func bindToService() {
        service.onPlaybackStateChanged = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updatePlayButton()
                }
            }
        service.onProgressChanged = { [weak self] current, total in
            DispatchQueue.main.async {
                let progress = total > 0 ? Float(current / total) : 0
                self?.progressBar.progress = progress
                
                // ✅ Сохраняем прогресс через UserDefaults
                if let podcastId = self?.currentPodcastId {
                    // Сохраняем прогресс (UserDefaults)
                    ContinueListeningService.shared.save(podcastId: podcastId, progress: progress)
                    
                    // Если подкаст дослушан до 95%, удаляем из списка продолжения
                    if progress >= 0.95 {
                        ContinueListeningService.shared.remove(podcastId: podcastId)
                    }
                }
            }
        }
    }
    

    
    @objc private func playTapped() {
        service.togglePlayback()
        updatePlayButton()
    }
    
    func configure(with podcast: PodcastFull) {
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        currentPodcastId = podcast.id
        
        // Восстанавливаем прогресс
        progressBar.progress = Float(podcast.progress)
        
        // Если прогресс > 0, показываем кнопку "Продолжить" или автоматически запускаем
        if podcast.progress > 0 {
            print("🎧 Continue from \(Int(podcast.progress * 100))%")
            // Здесь можно установить плеер на нужное время
        }
    }
}

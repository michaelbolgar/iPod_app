//
//  PlayerService.swift
//  iPods
//
//  Created by Nodira Shukurova on 24/04/26.
//
import Foundation
import AVFoundation
import Networking

final class PlayerService {
    
    static let shared = PlayerService()
    
    var onEpisodeChanged: ((Episode?) -> Void)?
    var onPlaybackStateChanged: ((Bool) -> Void)?
    var onProgressChanged: ((Double, Double) -> Void)?
    
    private(set) var episodes: [Episode] = []
    private(set) var currentIndex: Int = 0
    
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    
    var currentEpisode: Episode? {
        guard episodes.indices.contains(currentIndex) else { return nil }
        return episodes[currentIndex]
    }
    
    var isPlaying: Bool {
        player?.rate != 0
    }
    
    var hasNext: Bool {
        currentIndex + 1 < episodes.count
    }
    
    var hasPrevious: Bool {
        currentIndex > 0
    }
    
    var currentTime: Double {
        player?.currentTime().seconds ?? 0
    }
    
    var duration: Double {
        guard let d = player?.currentItem?.duration.seconds, d.isFinite else { return 0 }
        return d
    }
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    deinit {
        removeObserver()
        NotificationCenter.default.removeObserver(self)
    }
    
    func startPlayback(episodes: [Episode], index: Int) {
        guard !episodes.isEmpty else { return }
        guard episodes.indices.contains(index) else { return }
        
        self.episodes = episodes
        self.currentIndex = index
        
        configureAudioSession()
        playCurrent()
    }
    
    func togglePlayback() {
        isPlaying ? pause() : play()
    }
    
    func play() {
        configureAudioSession()
#warning("попробуйте тут вызывать setActive(true), а не configureAudioSession(). Есть подозрение, что ваш способ будет расходовать слишком много ресурсов")

        player?.play()
        onPlaybackStateChanged?(true)
    }
    
    func pause() {
        player?.pause()
        onPlaybackStateChanged?(false)
    }
    
    func next() {
        guard hasNext else { return }
        currentIndex += 1
        playCurrent()
    }
    
    func previous() {
        if currentTime > 5 {
            seek(to: 0)
            return
        }
        
        guard hasPrevious else {
            seek(to: 0)
            return
        }
        
        currentIndex -= 1
        playCurrent()
    }
    
    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: time)
    }
    
    func seek(toProgress progress: Float) {
        let total = duration
        guard total > 0 else { return }
        let target = Double(progress) * total
        seek(to: target)
    }
    
    private func playCurrent() {
        guard let episode = currentEpisode,
              let url = episode.audioURL else { return }
        
        removeObserver()
        
        let item = AVPlayerItem(url: url)
        
        if player == nil {
            player = AVPlayer(playerItem: item)
        } else {
            player?.replaceCurrentItem(with: item)
        }
        
        addObserver()
        player?.play()
        
        onEpisodeChanged?(episode)
        onPlaybackStateChanged?(true)
    }
    
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
    }
    
    @objc
    private func handleFinish() {
        if hasNext {
            next()
        } else {
            pause()
            seek(to: 0)
        }
    }
    
    private func addObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        
        timeObserverToken = player?.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            guard let self else { return }
            
            let current = time.seconds.isFinite ? time.seconds : 0
            let total = self.player?.currentItem?.duration.seconds.isFinite == true
            
            ? self.player?.currentItem?.duration.seconds ?? 0
            : 0
            
            self.onProgressChanged?(current, total)
        }
    }
    
    private func removeObserver() {
        guard let token = timeObserverToken else { return }
        player?.removeTimeObserver(token)
        timeObserverToken = nil
    }
}

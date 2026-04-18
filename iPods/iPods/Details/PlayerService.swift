//
//  PlayerService.swift
//  
//
//  Created by Madina Samadzoda on 18/04/26.
//

import Foundation


final class PlayerService {

    private var player: AVPlayer?

    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }

    func observeProgress(_ block: @escaping (Float) -> Void) {
        guard let player else { return }

        player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { time in
            let current = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? .zero)
            if duration > 0 {
                block(Float(current / duration))
            }
        }
    }
}

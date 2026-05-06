//
//  Podcast.swift
//  iPods
//
//  Created by Administration  on 17/04/26.
//

import Foundation

struct PodcastFull {
    let id: Int
    let title: String
    let author: String
    let genre: String
    let rating: Double
    let episodeCount: Int
    let description: String
    let progress: Double
    let artworkURL: URL?
    let feedID: Int?
}

extension PodcastFull {
    init(from podcast: Podcast) {
        self.id = podcast.id
        self.title = podcast.title
        self.author = podcast.author
        self.genre = podcast.genre
        self.rating = podcast.rating
        self.episodeCount = podcast.episodeCount
        self.description = podcast.description
        self.progress = 0.0
        self.artworkURL = nil
        self.feedID = nil
    }
}

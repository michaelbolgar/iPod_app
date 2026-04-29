//
//  Podcast.swift
//  iPods
//
//  Created by Administration  on 17/04/26.
//

import Foundation

struct PodcastFull {
    let title: String
    let author: String
    let genre: String
    let rating: Double
    let episodeCount: Int
    let description: String
    var progress: Float
    var artworkURL: URL? = nil
    var feedID: Int? = nil
}

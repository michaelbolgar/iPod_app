//
//  Podcast.swift
//  iPods
//
//  Created by Administration  on 17/04/26.
//

import Foundation

struct Podcast: Identifiable {
    let id: Int
    let title: String
    let author: String
    let description: String
    let rating: Double
    let episodeCount: Int
    let genre: String
}

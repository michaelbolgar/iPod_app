//
//  PodcastUI.swift
//  iPods
//
//  Created by Administration  on 24/04/26.
//


import Foundation

struct PodcastUI: Identifiable {
    let id: Int
    let title: String
    let author: String
    let description: String
    let episodeCount: Int
    let genre: String
    let imageURL: URL?
}

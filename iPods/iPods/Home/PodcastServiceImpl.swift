//
//  PodcastServiceImpl.swift
//  iPods
//
//  Created by Administration  on 24/04/26.
//
import Foundation
final class PodcastServiceImpl: PodcastService {

    func fetchTrending() async throws -> [Podcast] {
        [
            Podcast(
                id: 1,
                title: "Trending 1",
                author: "Author A",
                description: "Tech & startups podcast",
                rating: 4.8,
                episodeCount: 120,
                genre: "Technology"
            ),
            Podcast(
                id: 2,
                title: "Trending 2",
                author: "Author B",
                description: "Business interviews and insights",
                rating: 4.6,
                episodeCount: 95,
                genre: "Business"
            ),
            Podcast(
                id: 3,
                title: "Trending 3",
                author: "Author C",
                description: "Deep conversations and stories",
                rating: 4.7,
                episodeCount: 140,
                genre: "Lifestyle"
            )
        ]
    }
}

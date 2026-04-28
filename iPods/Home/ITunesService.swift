//
//  ITunesService.swift
//  iPods
//
//  Created by Administration  on 28/04/26.
//


// ITunesService.swift
// iPods
// Бесплатный iTunes API — без регистрации и ключей

import Foundation

enum ITunesService {

    // MARK: - iTunes Response Models

    private struct Response: Decodable {
        let results: [Item]
    }

    private struct Item: Decodable {
        let trackName: String?
        let collectionName: String?
        let artistName: String?
        let primaryGenreName: String?
        let trackCount: Int?
        let artworkUrl600: String?

        var title: String { trackName ?? collectionName ?? "Unknown" }
    }

    // MARK: - Public API

    static func fetchTrending() async -> [PodcastFull] {
        let urlString = "https://itunes.apple.com/search?term=podcast&media=podcast&entity=podcast&limit=10&country=us"
        return await fetch(urlString: urlString)
    }

    static func search(query: String) async -> [PodcastFull] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return [] }

        let urlString = "https://itunes.apple.com/search?term=\(encoded)&media=podcast&entity=podcast&limit=20"
        return await fetch(urlString: urlString)
    }

    // MARK: - Private

    private static func fetch(urlString: String) async -> [PodcastFull] {
        guard let url = URL(string: urlString) else { return [] }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            return decoded.results.map { item in
                PodcastFull(
                    title: item.title,
                    author: item.artistName ?? "",
                    genre: item.primaryGenreName ?? "Podcast",
                    rating: 0,
                    episodeCount: item.trackCount ?? 0,
                    description: "",
                    artworkURL: item.artworkUrl600.flatMap { URL(string: $0) },
                    progress: 0
                )
            }
        } catch {
            print("‼️ ITunesService error:", error.localizedDescription)
            return []
        }
    }
}
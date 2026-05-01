//
//  PodcastService.swift
//  iPods
//
//  Created by Administration  on 24/04/26.
//


import Foundation

protocol PodcastService {
    func fetchTrending() async throws -> [Podcast]
}
   // func fetchTrending() async throws -> [Podcast]

private let service: PodcastService = PodcastServiceImpl()
private var podcasts: [PodcastUI] = []

func loadTrending() {
    Task {
        do {
            let result = try await service.fetchTrending()
           // self.podcasts = result.map { $0.toUI() }

            DispatchQueue.main.async {
                // например:
                // self.tableView.reloadData()
                // или collectionView.reloadData()
            }

        } catch {
            print("Error loading trending: \(error)")
        }
    }
}

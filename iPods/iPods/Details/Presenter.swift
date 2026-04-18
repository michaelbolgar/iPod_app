//
//  Presenter.swift
//  
//
//  Created by Madina Samadzoda on 18/04/26.
//

import Foundation

protocol DetailView: AnyObject {
    func display(_ model: DetailViewModel)
    func displayEpisodes(_ items: [EpisodeViewModel])
    func showError(_ message: String)
}

final class DetailPresenter {

    weak var view: DetailView?

    private let network: NetworkClient

    private var feedId: Int?

    init(network: NetworkClient) {
        self.network = network
    }

    func load() async {
        do {
            let response: PodcastResponse = try await network.request(
                endpoint: .search("science")
            )

            guard let podcast = response.feeds.first else { return }

            self.feedId = podcast.id

            let vm = DetailViewModel(
                title: podcast.title,
                author: podcast.author,
                description: podcast.description,
                imageURL: URL(string: podcast.image)
            )

            view?.display(vm)

            await loadEpisodes()

        } catch {
            view?.showError("Ошибка загрузки")
        }
    }

    private func loadEpisodes() async {
        guard let feedId else { return }

        do {
            let response: EpisodesResponse = try await network.request(
                endpoint: .episodesByFeed(feedId)
            )

            let items = response.items.map {
                EpisodeViewModel(
                    title: $0.title,
                    date: $0.datePublishedPretty
                )
            }

            view?.displayEpisodes(items)

        } catch {
            print(error)
        }
    }
}

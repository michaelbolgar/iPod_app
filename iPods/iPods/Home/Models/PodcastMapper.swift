import Foundation

struct PodcastMapper {
    static func toFull(_ podcast: Podcast) -> PodcastFull {
        return PodcastFull(
            id: podcast.id,
            title: podcast.title,
            author: podcast.author,
            genre: podcast.genre,
            rating: podcast.rating,
            episodeCount: podcast.episodeCount,
            description: podcast.description,
            progress: 0.0,
            artworkURL: podcast.imageURL,   
            feedID: podcast.id
        )
    }
}

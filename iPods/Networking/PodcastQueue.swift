import Foundation

/// An ordered collection of episodes with a current position, used by the player
/// to move to the next or previous episode.
@MainActor
public final class PodcastQueue {
    public private(set) var items: [Episode]
    public private(set) var currentIndex: Int

    /// Creates a queue from the given episodes.
    /// - Parameters:
    ///   - items: Episodes in playback order.
    ///   - startIndex: Start position. Defaults to `0` if out of range.
    public init(items: [Episode], startIndex: Int = 0) {
        self.items = items
        self.currentIndex = items.indices.contains(startIndex) ? startIndex : 0
    }

    /// Episode at the current position, or `nil` if the queue is empty.
    public var current: Episode? {
        guard items.indices.contains(currentIndex) else { return nil }
        return items[currentIndex]
    }

    public var hasNext: Bool { currentIndex + 1 < items.count }
    public var hasPrevious: Bool { currentIndex > 0 }

    /// Advances to the next episode and returns it, or `nil` at the end of the queue.
    @discardableResult
    public func next() -> Episode? {
        guard hasNext else { return nil }
        currentIndex += 1
        return current
    }

    /// Moves to the previous episode and returns it, or `nil` at the start of the queue.
    @discardableResult
    public func previous() -> Episode? {
        guard hasPrevious else { return nil }
        currentIndex -= 1
        return current
    }
}

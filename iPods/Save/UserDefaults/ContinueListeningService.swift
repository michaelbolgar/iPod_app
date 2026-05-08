//
//  Untitled 2.swift
//  iPods
//
//  Created by Sakina Rajabova on 08/05/26.
//

import Foundation


class ContinueListeningService {
    static let shared = ContinueListeningService()
    private let key = "continueListening"
    
   
    func save(podcastId: Int, progress: Float) {
        // Load current items from UserDefaults

    var items = load()
    var shouldNotify = false
    
    // Update existing item or create a new one
    if let index = items.firstIndex(where: { $0.podcastId == podcastId }) {
        let oldProgress = items[index].progress
        items[index].progress = progress
        items[index].lastListened = Date()
        
        // Notify only if progress crossed 95% threshold (item removed from list)
        if oldProgress < 0.95 && progress >= 0.95 {
            shouldNotify = true
        }
    } else {
        items.append(ContinueListeningItem(podcastId: podcastId, progress: progress, lastListened: Date()))
        shouldNotify = true // New item added to list
    }
    
    // Sort by most recent listening date (newest first)
    items.sort { $0.lastListened > $1.lastListened }
    
    // Keep only the last 3 items
    if items.count > 3 {
        let oldCount = items.count
        items = Array(items.prefix(3))
        if oldCount != items.count {
            shouldNotify = true // Items were removed from list
        }
    }
    
    // Keep only items with progress between 0 and 0.95 (not finished)
    let filtered = items.filter { $0.progress < 0.95 && $0.progress > 0 }
    
    // Check if count changed
    let oldFilteredCount = UserDefaults.standard.data(forKey: key).flatMap { try? JSONDecoder().decode([ContinueListeningItem].self, from: $0) }?.count ?? 0
    if oldFilteredCount != filtered.count {
        shouldNotify = true
    }
    
    // Save to UserDefaults
    if let data = try? JSONEncoder().encode(filtered) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    // Notify only if list actually changed
    if shouldNotify {
        NotificationCenter.default.post(name: NSNotification.Name("continueListeningUpdated"), object: nil)
    }
}
    

    func load() -> [ContinueListeningItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([ContinueListeningItem].self, from: data) else {
            return []
        }
        return items.filter { $0.progress < 0.95 && $0.progress > 0 }
    }
    
    func remove(podcastId: Int) {
        var items = load()
        items.removeAll { $0.podcastId == podcastId }
        
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

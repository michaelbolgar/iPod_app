
//
//  Created by Sakina Rajabova on 22/04/26.
//

import CoreData

public class ListeningService {
    public static let shared = ListeningService()
    private let context = CoreDataStack.shared.context
    
    // MARK: - Progress
    public func saveProgress(podcastId: Int, progress: Float) {
        let request: NSFetchRequest<ListeningHistory> = ListeningHistory.fetchRequest()
        request.predicate = NSPredicate(format: "podcastId == %d", podcastId)
        
        let history: ListeningHistory
        if let existing = try? context.fetch(request).first {
            history = existing
        } else {
            history = ListeningHistory(context: context)
            history.podcastId = Int64(podcastId)
        }
        
        history.progress = progress
        history.lastListened = Date()
        CoreDataStack.shared.saveContext()
    }
    
    public func loadContinueListening() -> [ListeningHistory] {
        let request: NSFetchRequest<ListeningHistory> = ListeningHistory.fetchRequest()
        request.predicate = NSPredicate(format: "progress < 0.95 AND progress > 0")
        request.sortDescriptors = [NSSortDescriptor(key: "lastListened", ascending: false)]
        request.fetchLimit = 3
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    public func getProgress(podcastId: Int) -> Float {
        let request: NSFetchRequest<ListeningHistory> = ListeningHistory.fetchRequest()
        request.predicate = NSPredicate(format: "podcastId == %d", podcastId)
        
        do {
            if let history = try context.fetch(request).first {
                return history.progress
            }
        } catch { }
        return 0
    }
    
    // MARK: - Search History
    public func saveSearchQuery(_ query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newSearch = SearchHistory(context: context)
        newSearch.query = query
        newSearch.timestamp = Date()
        CoreDataStack.shared.saveContext()
    }
    
    public func loadSearchHistory(limit: Int = 5) -> [SearchHistory] {
        let request: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = limit
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    public func clearSearchHistory() {
        let request: NSFetchRequest<NSFetchRequestResult> = SearchHistory.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try? context.execute(deleteRequest)
        CoreDataStack.shared.saveContext()
    }
}

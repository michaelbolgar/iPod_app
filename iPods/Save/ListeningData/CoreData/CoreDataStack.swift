//
//  Untitled 2.swift
//  iPods
//
//  Created by Sakina Rajabova on 08/05/26.
//

import CoreData

public class CoreDataStack {
    public static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ListeningHistory")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}

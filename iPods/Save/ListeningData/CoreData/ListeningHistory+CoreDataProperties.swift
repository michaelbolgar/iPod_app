//
//  ListeningHistory+CoreDataProperties.swift
//  ListeningData
//
//  Created by Sakina Rajabova on 08/05/26.
//
//

public import Foundation
public import CoreData


extension ListeningHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListeningHistory> {
        return NSFetchRequest<ListeningHistory>(entityName: "ListeningHistory")
    }

    @NSManaged public var podcastId: Int64
    @NSManaged public var progress: Float
    @NSManaged public var lastListened: Date?

}

extension ListeningHistory : Identifiable {

}

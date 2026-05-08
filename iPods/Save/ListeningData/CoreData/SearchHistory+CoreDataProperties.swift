//
//  SearchHistory+CoreDataProperties.swift
//  ListeningData
//
//  Created by Sakina Rajabova on 08/05/26.
//
//

public import Foundation
public import CoreData


public typealias SearchHistoryCoreDataPropertiesSet = NSSet

extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var query: String?
    @NSManaged public var timestamp: Date?

}

extension SearchHistory : Identifiable {

}

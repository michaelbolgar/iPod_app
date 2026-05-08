//
//  Untitled.swift
//  iPods
//
//  Created by Sakina Rajabova on 08/05/26.
//

import Foundation

struct ContinueListeningItem: Codable {
    let podcastId: Int
    var progress: Float
    var lastListened: Date
}

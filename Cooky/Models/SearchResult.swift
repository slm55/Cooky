//
//  SearchResult.swift
//  Cooky
//
//  Created by Aslan Murat on 30.07.2022.
//

import Foundation

// MARK: - Welcome
struct SearchResponse: Codable {
    let results: [SearchResult]
}

// MARK: - Result
struct SearchResult: Codable {
    let searchValue: String

    enum CodingKeys: String, CodingKey {
        case searchValue = "search_value"
    }
}
